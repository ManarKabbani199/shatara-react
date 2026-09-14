'use client';

import {
  useCallback,
  useEffect,
  useState,
} from 'react';
import { HiChevronDown } from 'react-icons/hi';
import { useAuth } from '@/features/auth/hooks/use-auth';

const PLAY_URL =
  'https://api.shatara.sa/play/';

const CREATE_PLAY_TOKEN_URL =
  'https://api.shatara.sa/create_play_token.php';

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

export function ShataraPreview() {
  const { user, isLoggedIn } = useAuth();

  const [images, setImages] =
    useState<string[]>([]);

  const [currentImage, setCurrentImage] =
    useState(0);

  const [openingPlay, setOpeningPlay] =
    useState(false);

  useEffect(() => {
    async function loadImages() {
      try {
        const res = await fetch(
          'https://api.shatara.sa/ShataraGame/list_uploads.php?limit=5',
          {
            cache: 'no-store',
            mode: 'cors',
          }
        );

        const data = await res.json();

        const imageUrls: string[] =
          Array.isArray(data.images)
            ? data.images
            : [];

        setImages(
          imageUrls.slice(0, 5)
        );

        setCurrentImage(0);
      } catch (error) {
        console.log(
          'Error loading images:',
          error
        );
      }
    }

    void loadImages();
  }, []);

  useEffect(() => {
    if (images.length <= 1) {
      return;
    }

    const timer =
      window.setInterval(() => {
        setCurrentImage(
          (prev) =>
            (prev + 1) %
            images.length
        );
      }, 5000);

    return () => {
      window.clearInterval(timer);
    };
  }, [images.length]);

  const getAuthenticatedUser =
    useCallback((): AuthUserData | null => {
      if (user) {
        const rawUser =
          user as unknown as {
            user?: AuthUserData;
          } & AuthUserData;

        const authUser =
          rawUser.user ??
          rawUser;

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
          localStorage.getItem('user');

        if (!savedUser) {
          return null;
        }

        const parsedValue: unknown =
          JSON.parse(savedUser);

        if (
          typeof parsedValue !== 'object' ||
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

  const handlePlayClick =
    useCallback(async () => {
      if (openingPlay) {
        return;
      }

      setOpeningPlay(true);

      const playWindow = window.open(
        'about:blank',
        '_blank'
      );

      const openPlayPage = (
        url: string
      ) => {
        if (playWindow) {
          playWindow.opener = null;
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
         * زائر
         */
        if (!isLoggedIn) {
          openPlayPage(PLAY_URL);
          return;
        }

        /*
         * مستخدم مسجل
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
          'Preview User ID:',
          userId
        );

        console.log(
          'Preview User UID:',
          userUid
        );

        console.log(
          'Preview User Name:',
          authUser.name
        );

        if (!userId && !userUid) {
          throw new Error(
            'بيانات المستخدم لا تحتوي على id أو uid.'
          );
        }

        const response = await fetch(
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
            body: JSON.stringify({
              id: userId,
              uid: userUid,
            }),
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

        let data: CreateTokenResponse;

        try {
          data = JSON.parse(
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

        const playUrl =
          `${PLAY_URL}?token=${encodeURIComponent(
            data.token
          )}`;

        console.log(
          'Preview final play URL:',
          playUrl
        );

        openPlayPage(playUrl);
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
                font-family: Arial, sans-serif;
                background: #ffffff;
                color: #b91c1c;
                text-align: center;
              "
            >
              <div>
                <h2>تعذر فتح لعبة شطارة</h2>
                <p>${message}</p>
              </div>
            </div>
          `;
        } else {
          window.alert(message);
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

  const imageSrc =
    images.length > 0
      ? images[currentImage]
      : '/assets/images/shatttt.png';

  return (
    <section
      className="bg-white py-[70px]"
      dir="rtl"
    >
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 gap-[25px]">
          <div className="rounded-[24px] bg-[#AB86B9] p-4 shadow-xl sm:p-6">
            <div className="flex flex-col overflow-hidden rounded-[16px] bg-white lg:flex-row">

              <div className="flex w-full flex-col bg-[#AB86B9] lg:flex-[2.5]">
                <div className="flex items-center justify-between px-4 py-2.5 text-[11px] font-bold text-white">
                  <div className="flex items-center gap-2">
                    <span className="opacity-80">
                      IM 2343
                    </span>

                    <span>
                      Caissaisabelle
                    </span>
                  </div>

                  <span className="rounded bg-white/20 px-2 py-0.5">
                    1:43
                  </span>
                </div>

                <div className="relative aspect-[4/3] bg-[#E8DCC4] p-3 sm:aspect-square lg:aspect-auto lg:flex-1">
                  <div className="relative h-full w-full">
                    <img
                      src={imageSrc}
                      alt="لوحة شطارة"
                      className="h-full w-full object-contain"
                    />

                    <div className="absolute left-2 top-2 rounded bg-black/60 px-2 py-1 text-xs text-white">
                      {images.length > 0
                        ? `${currentImage + 1} / ${images.length}`
                        : '0 / 0'}
                    </div>
                  </div>
                </div>

                <div className="flex items-center justify-between px-4 py-2.5 text-[11px] font-bold text-white">
                  <span className="rounded bg-white/20 px-2 py-0.5">
                    1:43
                  </span>

                  <div className="flex items-center gap-2">
                    <span>
                      Caissaisabelle
                    </span>

                    <span className="opacity-80">
                      IM 2343
                    </span>
                  </div>
                </div>
              </div>

              <div className="flex w-full flex-col border-t border-gray-100 bg-white lg:flex-[1] lg:border-l lg:border-t-0">
                <div className="border-b border-gray-100 p-4">
                  <div className="flex items-center justify-between">
                    <button
                      type="button"
                      className="flex items-center gap-1 rounded border border-gray-200 bg-white px-2 py-1 text-[10px] font-bold text-gray-500 shadow-sm"
                    >
                      <HiChevronDown className="h-3 w-3" />
                      <span>بليتز</span>
                    </button>

                    <span className="text-xs font-bold text-gray-600">
                      مباريات قائمة الآن
                    </span>
                  </div>
                </div>

                <div className="max-h-[250px] overflow-y-auto lg:max-h-none lg:flex-1">
                  {[1, 2, 3, 4, 5, 6, 7, 8].map(
                    (i) => (
                      <div
                        key={i}
                        className={`flex items-center justify-between px-5 py-3 text-[11px] font-bold transition-colors ${
                          i % 2 === 0
                            ? 'bg-gray-50/80'
                            : 'bg-white'
                        }`}
                      >
                        <span className="text-gray-400">
                          32
                        </span>

                        <span className="text-gray-600">
                          Z2_123 {i}
                        </span>
                      </div>
                    )
                  )}
                </div>

                <div className="border-t border-gray-100 bg-white p-4 lg:border-t-0">
                  <button
                    type="button"
                    className="w-full rounded-lg bg-gray-100 py-2.5 text-[11px] font-bold text-gray-500 transition-colors hover:bg-gray-200"
                  >
                    عرض الكل
                  </button>
                </div>
              </div>
            </div>

            <div className="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2 sm:gap-6">
              <button
                type="button"
                onClick={handlePlayClick}
                disabled={openingPlay}
                className="flex cursor-pointer items-center justify-center gap-3 rounded-xl bg-white px-4 py-3 text-xs font-bold text-gray-500 shadow-sm transition-colors hover:bg-gray-50 disabled:cursor-wait disabled:opacity-60 sm:text-sm"
              >
                <span className="h-4 w-4 rounded border-2 border-[#AB86B9] bg-[#AB86B9] sm:h-5 sm:w-5" />

                <span>
                  {openingPlay
                    ? 'جاري فتح اللعبة...'
                    : 'تحدي أصدقائك'}
                </span>
              </button>

              <button
                type="button"
                onClick={handlePlayClick}
                disabled={openingPlay}
                className="flex cursor-pointer items-center justify-center gap-3 rounded-xl bg-white px-4 py-3 text-xs font-bold text-gray-500 shadow-sm transition-colors hover:bg-gray-50 disabled:cursor-wait disabled:opacity-60 sm:text-sm"
              >
                <span className="h-4 w-4 rounded border-2 border-[#AB86B9] bg-[#AB86B9] sm:h-5 sm:w-5" />

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