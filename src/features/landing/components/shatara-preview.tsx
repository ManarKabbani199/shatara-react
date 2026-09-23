'use client';

import {
  useCallback,
  useEffect,
  useState,
} from 'react';
import { HiPlay } from 'react-icons/hi';

import { useAuth } from '@/features/auth/hooks/use-auth';

const PLAY_URL =
  'https://api.shatara.sa/play/';

const CREATE_PLAY_TOKEN_URL =
  'https://api.shatara.sa/create_play_token.php';

const IMAGES_API_URL =
  'https://api.shatara.sa/ShataraGame/list_uploads.php';

const FALLBACK_IMAGE =
  '/assets/images/shatttt.png';

type AuthUserData = {
  id?: number | string;
  uid?: string;
  name?: string;
  username?: string;
  user_id?: number | string;
};

type CreateTokenResponse = {
  success?: boolean;
  token?: string;
  message?: string;
};

type ImagesResponse = {
  success?: boolean;
  count?: number;
  images?: string[];
};

export function ShataraPreview() {
  const {
    user,
    isLoggedIn,
  } = useAuth();

  const [openingPlay, setOpeningPlay] =
    useState(false);

  /*
  |--------------------------------------------------------------------------
  | صور آخر مباراة
  |--------------------------------------------------------------------------
  */

  const [images, setImages] =
    useState<string[]>([]);

  const [
    currentImage,
    setCurrentImage,
  ] = useState(0);

  const [
    loadingImages,
    setLoadingImages,
  ] = useState(true);

  const [
    imagesError,
    setImagesError,
  ] = useState('');

  /*
  |--------------------------------------------------------------------------
  | تحميل آخر 5 صور
  |--------------------------------------------------------------------------
  */

  const loadImages =
    useCallback(async () => {
      try {
        setImagesError('');

        const response =
          await fetch(
            `${IMAGES_API_URL}?limit=5&t=${Date.now()}`,
            {
              method: 'GET',
              mode: 'cors',
              cache: 'no-store',
              headers: {
                Accept:
                  'application/json',
              },
            }
          );

        if (!response.ok) {
          throw new Error(
            `HTTP ${response.status}`
          );
        }

        const data =
          (await response.json()) as ImagesResponse;

        const imageUrls =
          Array.isArray(data.images)
            ? data.images.filter(
                (
                  image
                ): image is string =>
                  typeof image ===
                    'string' &&
                  image.trim()
                    .length > 0
              )
            : [];

        console.log(
          'آخر صور المباراة:',
          imageUrls
        );

        if (
          imageUrls.length === 0
        ) {
          throw new Error(
            'لا توجد صور للمباراة حالياً'
          );
        }

        setImages(
          imageUrls.slice(0, 5)
        );

        setCurrentImage(0);
      } catch (error) {
        console.error(
          'خطأ تحميل صور المباراة:',
          error
        );

        setImagesError(
          error instanceof Error
            ? error.message
            : 'حدث خطأ أثناء تحميل الصور'
        );

        setImages([]);
        setCurrentImage(0);
      } finally {
        setLoadingImages(false);
      }
    }, []);

  /*
  |--------------------------------------------------------------------------
  | تحميل الصور عند فتح الصفحة
  | وتحديث القائمة كل دقيقة
  |--------------------------------------------------------------------------
  */

  useEffect(() => {
    void loadImages();

    const refreshInterval =
      window.setInterval(() => {
        void loadImages();
      }, 60000);

    return () => {
      window.clearInterval(
        refreshInterval
      );
    };
  }, [loadImages]);

  /*
  |--------------------------------------------------------------------------
  | تغيير الصورة كل 5 ثوانٍ
  |--------------------------------------------------------------------------
  */

  useEffect(() => {
    if (images.length < 2) {
      return;
    }

    const imageInterval =
      window.setInterval(() => {
        setCurrentImage(
          (previousImage) =>
            (previousImage + 1) %
            images.length
        );
      }, 5000);

    return () => {
      window.clearInterval(
        imageInterval
      );
    };
  }, [images.length]);

  /*
  |--------------------------------------------------------------------------
  | الصورة الحالية
  |--------------------------------------------------------------------------
  */

  const imageSrc =
    images.length > 0
      ? images[currentImage] ??
        FALLBACK_IMAGE
      : FALLBACK_IMAGE;

  /*
  |--------------------------------------------------------------------------
  | بيانات المستخدم
  |--------------------------------------------------------------------------
  */

  const getAuthenticatedUser =
    useCallback(():
      | AuthUserData
      | null => {
      if (user) {
        const rawUser =
          user as unknown as {
            user?: AuthUserData;
          } & AuthUserData;

        const authUser =
          rawUser.user ?? rawUser;

        if (
          authUser.id ||
          authUser.user_id ||
          authUser.uid
        ) {
          return authUser;
        }
      }

      try {
        const savedUser =
          localStorage.getItem(
            'user'
          );

        if (!savedUser) {
          return null;
        }

        const parsedValue: unknown =
          JSON.parse(savedUser);

        if (
          typeof parsedValue !==
            'object' ||
          parsedValue === null
        ) {
          return null;
        }

        const rawStoredUser =
          parsedValue as {
            user?: AuthUserData;
          } & AuthUserData;

        const storedUser =
          rawStoredUser.user ??
          rawStoredUser;

        if (
          storedUser.id ||
          storedUser.user_id ||
          storedUser.uid
        ) {
          return storedUser;
        }
      } catch (error) {
        console.error(
          'فشل قراءة المستخدم من localStorage:',
          error
        );
      }

      return null;
    }, [user]);

  /*
  |--------------------------------------------------------------------------
  | فتح اللعبة
  |--------------------------------------------------------------------------
  */

  const handlePlayClick =
    useCallback(async () => {
      if (openingPlay) {
        return;
      }

      setOpeningPlay(true);

      const playWindow =
        window.open(
          'about:blank',
          '_blank'
        );

      const openPlayPage = (
        url: string
      ) => {
        if (playWindow) {
          playWindow.opener =
            null;

          playWindow.location.href =
            url;
        } else {
          window.location.href =
            url;
        }
      };

      try {
        console.log(
          'Preview isLoggedIn:',
          isLoggedIn
        );

        console.log(
          'Preview user:',
          user
        );

        /*
        |--------------------------------------------------------------------------
        | زائر
        |--------------------------------------------------------------------------
        */

        if (!isLoggedIn) {
          openPlayPage(
            PLAY_URL
          );

          return;
        }

        /*
        |--------------------------------------------------------------------------
        | مستخدم مسجل
        |--------------------------------------------------------------------------
        */

        const authUser =
          getAuthenticatedUser();

        if (!authUser) {
          throw new Error(
            'المستخدم مسجل دخول، لكن لم يتم العثور على id أو uid.'
          );
        }

        const userId =
          authUser.id ??
          authUser.user_id;

        const userUid =
          authUser.uid;

        console.log(
          'Name:',
          authUser.name
        );

        console.log(
          'Username:',
          authUser.username
        );

        console.log(
          'ID:',
          userId
        );

        if (
          !userId &&
          !userUid
        ) {
          throw new Error(
            'بيانات المستخدم لا تحتوي على id أو uid.'
          );
        }

        /*
        |--------------------------------------------------------------------------
        | إنشاء Token
        |--------------------------------------------------------------------------
        */

        const response =
          await fetch(
            CREATE_PLAY_TOKEN_URL,
            {
              method: 'POST',
              mode: 'cors',
              headers: {
                'Content-Type':
                  'application/json',

                Accept:
                  'application/json',
              },

              body: JSON.stringify(
                {
                  id: userId,
                  uid: userUid,
                }
              ),
            }
          );

        const responseText =
          await response.text();

        console.log(
          'Preview create token status:',
          response.status
        );

        console.log(
          'Preview create token response:',
          responseText
        );

        let data:
          CreateTokenResponse;

        try {
          data =
            JSON.parse(
              responseText
            ) as CreateTokenResponse;
        } catch {
          throw new Error(
            'استجابة create_play_token.php ليست JSON صحيحة.'
          );
        }

        if (
          !response.ok ||
          data.success !== true ||
          !data.token
        ) {
          throw new Error(
            data.message ||
              `فشل إنشاء رمز دخول اللعب. HTTP ${response.status}`
          );
        }

        /*
        |--------------------------------------------------------------------------
        | رابط اللعبة النهائي
        |--------------------------------------------------------------------------
        */

        const playUrl =
          `${PLAY_URL}?token=${encodeURIComponent(
            data.token
          )}`;

        console.log(
          'Preview final play URL:',
          playUrl
        );

        openPlayPage(
          playUrl
        );
      } catch (error) {
        console.error(
          'خطأ فتح اللعبة من Preview:',
          error
        );

        const message =
          error instanceof Error
            ? error.message
            : String(error);

        if (playWindow) {
          playWindow.document.title =
            'تعذر فتح لعبة شطارة';

          playWindow.document.body.innerHTML = `
            <div
              dir="rtl"
              style="
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0;
                padding: 30px;
                box-sizing: border-box;
                font-family: Arial, sans-serif;
                background: #ffffff;
                color: #b91c1c;
                text-align: center;
              "
            >
              <div>
                <h2>
                  تعذر فتح لعبة شطارة
                </h2>

                <p>
                  ${message}
                </p>
              </div>
            </div>
          `;
        } else {
          window.alert(
            message
          );
        }
      } finally {
        setOpeningPlay(false);
      }
    }, [
      getAuthenticatedUser,
      isLoggedIn,
      openingPlay,
      user,
    ]);

  /*
  |--------------------------------------------------------------------------
  | UI
  |--------------------------------------------------------------------------
  */

  return (
    <section
      className="bg-white py-[70px]"
      dir="rtl"
    >
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="rounded-[24px] bg-[#AB86B9] p-4 shadow-xl sm:p-6">

          <div className="flex flex-col items-stretch overflow-hidden rounded-[16px] bg-white lg:flex-row">

            {/* =========================
                صور آخر مباراة
            ========================== */}

            <div className="relative aspect-square w-full overflow-hidden bg-[#E8DCC4] p-3 lg:min-h-[380px] lg:flex-[2.5] lg:aspect-auto">

              {/* Loading */}

              {loadingImages && (
                <div className="absolute inset-0 z-20 flex items-center justify-center bg-[#E8DCC4] font-bold text-gray-600">
                  جاري تحميل آخر مباراة...
                </div>
              )}

              {/* Image */}

              <img
                key={`${currentImage}-${imageSrc}`}
                src={imageSrc}
                alt={`حركة شطارة ${
                  currentImage + 1
                }`}
                className="h-full w-full object-contain"
                onError={(
                  event
                ) => {
                  event.currentTarget.onerror =
                    null;

                  event.currentTarget.src =
                    FALLBACK_IMAGE;
                }}
              />

              {/* Number */}

              {!loadingImages &&
                images.length >
                  0 && (
                  <div className="absolute left-4 top-4 rounded-lg bg-black/60 px-3 py-1.5 text-xs font-bold text-white">
                    {currentImage +
                      1}{' '}
                    /{' '}
                    {
                      images.length
                    }
                  </div>
                )}

              {/* Error */}

              {!loadingImages &&
                imagesError && (
                  <div className="absolute bottom-4 left-4 right-4 rounded-lg bg-red-600/90 p-3 text-center text-xs font-bold text-white">
                    {
                      imagesError
                    }
                  </div>
                )}

              {/* Indicators */}

              {!loadingImages &&
                images.length >
                  1 && (
                  <div className="absolute bottom-4 left-1/2 flex -translate-x-1/2 gap-2">
                    {images.map(
                      (
                        _,
                        index
                      ) => (
                        <button
                          key={
                            index
                          }
                          type="button"
                          onClick={() =>
                            setCurrentImage(
                              index
                            )
                          }
                          aria-label={`عرض الصورة ${
                            index +
                            1
                          }`}
                          className={`h-2.5 w-2.5 cursor-pointer rounded-full transition-all ${
                            index ===
                            currentImage
                              ? 'scale-125 bg-[#AB86B9]'
                              : 'bg-white/80'
                          }`}
                        />
                      )
                    )}
                  </div>
                )}
            </div>

            {/* =========================
                Content
            ========================== */}

            <div className="flex w-full flex-col justify-center gap-4 border-t border-gray-100 p-6 text-right sm:p-8 lg:flex-[1] lg:border-l lg:border-t-0">

              <h2 className="text-2xl font-bold leading-snug text-[#6B4E45] sm:text-3xl">
                جرّب لعبة شطارة الآن
              </h2>

              <p className="text-sm font-medium leading-relaxed text-gray-500 sm:text-base">
                لعبة ذهنية استراتيجية تعتمد
                على بناء القرار وإدارة القوة.
                تحدَّ أصدقاءك والعب مباشرة من
                متصفحك.
              </p>

              <button
                type="button"
                onClick={
                  handlePlayClick
                }
                disabled={
                  openingPlay
                }
                className="mt-2 inline-flex self-start items-center justify-center gap-2 rounded-xl bg-[#AB86B9] px-6 py-3.5 text-sm font-bold text-white shadow-md transition-colors hover:bg-[#AB86B9]/90 disabled:cursor-wait disabled:opacity-60 sm:text-base"
              >
                <HiPlay className="h-5 w-5" />

                <span>
                  {openingPlay
                    ? 'جاري فتح اللعبة...'
                    : 'العب الآن'}
                </span>
              </button>

            </div>
          </div>
        </div>
      </div>
    </section>
  );
}