'use client';

import Link from 'next/link';
import Image from 'next/image';
import {
  useState,
  useCallback,
  useEffect,
} from 'react';

import {
  SITE,
  URLS,
} from '@/config/constants';

import {
  MdClose,
  MdLogin,
  MdLogout,
} from 'react-icons/md';

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

export function LandingNavbar() {
  const [mobileOpen, setMobileOpen] =
    useState(false);

  const [mounted, setMounted] =
    useState(false);

  const [openingPlay, setOpeningPlay] =
    useState(false);

  const {
    user,
    isLoggedIn,
    logout,
  } = useAuth();

  useEffect(() => {
    setMounted(true);
  }, []);

  const closeMobile =
    useCallback(() => {
      setMobileOpen(false);
    }, []);

  useEffect(() => {
    if (mobileOpen) {
      document.body.style.overflow =
        'hidden';
    } else {
      document.body.style.overflow =
        '';
    }

    return () => {
      document.body.style.overflow =
        '';
    };
  }, [mobileOpen]);

  useEffect(() => {
    if (!mobileOpen) {
      return;
    }

    const onKey = (
      event: KeyboardEvent
    ) => {
      if (event.key === 'Escape') {
        closeMobile();
      }
    };

    window.addEventListener(
      'keydown',
      onKey
    );

    return () => {
      window.removeEventListener(
        'keydown',
        onKey
      );
    };
  }, [
    mobileOpen,
    closeMobile,
  ]);

  const getAuthenticatedUser =
    useCallback((): AuthUserData | null => {
      /*
       * أولًا: نقرأ من useAuth
       */
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

      /*
       * حل احتياطي من localStorage
       */
      try {
        const savedUser =
          localStorage.getItem('user');

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

  const handlePlayClick =
    useCallback(async () => {
      if (openingPlay) {
        return;
      }

      closeMobile();
      setOpeningPlay(true);

      /*
       * نفتح التبويب فورًا حتى لا يمنعه المتصفح.
       */
      const playWindow =
        window.open(
          'about:blank',
          '_blank'
        );

      const openPlayPage = (
        url: string
      ) => {
        console.log(
          'فتح صفحة اللعب:',
          url
        );

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
          'LandingNavbar isLoggedIn:',
          isLoggedIn
        );

        console.log(
          'LandingNavbar user:',
          user
        );

        /*
         * المستخدم غير مسجل
         */
        if (!isLoggedIn) {
          console.log(
            'المستخدم زائر'
          );

          openPlayPage(
            PLAY_URL
          );

          return;
        }

        /*
         * المستخدم مسجل
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
         * إنشاء Token
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
              body: JSON.stringify({
                id: userId,
                uid: userUid,
              }),
            }
          );

        const responseText =
          await response.text();

        console.log(
          'create token status:',
          response.status
        );

        console.log(
          'create token response:',
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

        /*
         * فتح Flutter مع Token
         */
        const playUrl =
          `${PLAY_URL}?token=${encodeURIComponent(
            data.token
          )}`;

        console.log(
          'Final Play URL:',
          playUrl
        );

        openPlayPage(
          playUrl
        );
      } catch (error) {
        console.error(
          'خطأ فتح لعبة المستخدم:',
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
        setOpeningPlay(
          false
        );
      }
    }, [
      closeMobile,
      getAuthenticatedUser,
      isLoggedIn,
      openingPlay,
      user,
    ]);

  return (
    <>
      <header
        className="sticky top-0 z-50 w-full bg-white border-b border-gray-100"
        style={{
          willChange:
            'transform',
        }}
      >
        <nav
          className="max-w-7xl mx-auto px-4 py-4"
          dir="rtl"
        >
          {/* Desktop */}
          <div className="hidden lg:flex items-center justify-between w-full">
            <Link
              href="/"
              className="shrink-0"
            >
              <Image
                src="/assets/images/logoapp.png"
                alt={SITE.name}
                width={150}
                height={60}
                className="h-12 w-auto object-contain"
              />
            </Link>

            <div className="flex items-center gap-10">

              {/* Play */}
              <button
                type="button"
                onClick={
                  handlePlayClick
                }
                disabled={
                  openingPlay
                }
                className="flex items-center gap-1.5 text-base font-bold transition-colors hover:opacity-75 disabled:cursor-wait disabled:opacity-60"
                style={{
                  color:
                    '#6B4E45',
                }}
              >
                <NavIcon
                  src="/assets/images/chese.jpeg"
                  alt="إلعب الآن"
                />

                {openingPlay
                  ? 'جاري فتح اللعبة...'
                  : 'إلعب الآن'}
              </button>

              {/* Store */}
              <a
                href={
                  URLS.store
                }
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-1.5 text-base font-bold transition-colors hover:opacity-75"
                style={{
                  color:
                    '#6B4E45',
                }}
              >
                <NavIcon
                  src="/assets/images/store.jpeg"
                  alt="متجر شطارة"
                />

                متجر شطارة
              </a>

              {/* Club */}
              <a
                href={
                  URLS.club
                }
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-1.5 text-base font-bold transition-colors hover:opacity-75"
                style={{
                  color:
                    '#6B4E45',
                }}
              >
                <NavIcon
                  src="/assets/images/commuinty.jpeg"
                  alt="نادي شطارة"
                />

                نادي شطارة
              </a>

              {/* Guide */}
              <a
                href={
                  URLS.guide
                }
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center gap-1.5 text-base font-bold transition-colors hover:opacity-75"
                style={{
                  color:
                    '#6B4E45',
                }}
              >
                <NavIcon
                  src="/assets/images/book.jpeg"
                  alt="دليل شطارة"
                />

                دليل شطارة
              </a>
            </div>

            <div className="shrink-0 flex items-center gap-3">
              {mounted &&
              isLoggedIn ? (
                <button
                  type="button"
                  onClick={
                    logout
                  }
                  className="flex items-center gap-1.5 px-6 py-2 rounded-xl bg-brand-purple/10 text-brand-purple font-bold text-base transition-colors hover:bg-brand-purple hover:text-white"
                >
                  <MdLogout className="w-5 h-5" />

                  تسجيل الخروج
                </button>
              ) : (
                <Link
                  href="/login"
                  className="px-8 py-2 rounded-xl text-white font-bold text-lg shadow transition-all flex items-center justify-center hover:opacity-90"
                  style={{
                    backgroundColor:
                      '#AB86B9',
                  }}
                >
                  <MdLogin className="w-5 h-5 ml-1.5" />

                  تسجيل الدخول
                </Link>
              )}
            </div>
          </div>

          {/* Mobile */}
          <div className="flex lg:hidden items-center justify-between">
            <Link href="/">
              <Image
                src="/assets/images/logoapp.png"
                alt={SITE.name}
                width={120}
                height={50}
                className="h-9 w-auto object-contain"
              />
            </Link>

            <button
              type="button"
              onClick={() =>
                setMobileOpen(
                  true
                )
              }
              className="p-2 text-brand-brown"
              aria-label="فتح القائمة"
            >
              <svg
                className="w-6 h-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={
                    2
                  }
                  d="M4 6h16M4 12h16M4 18h16"
                />
              </svg>
            </button>
          </div>
        </nav>
      </header>

      {/* Mobile Drawer */}
      {mobileOpen && (
        <>
          <div
            className="fixed inset-0 bg-black/50 z-50"
            onClick={
              closeMobile
            }
          />

          <div
            className="fixed inset-y-0 end-0 w-64 bg-white shadow-2xl z-50 animate-drawer-in"
            dir="rtl"
            role="dialog"
            aria-modal="true"
            aria-label="قائمة التنقل"
          >
            <div className="flex items-center justify-between p-3 border-b border-brand-brown/10">
              <Image
                src="/assets/images/logoapp.png"
                alt={SITE.name}
                width={120}
                height={50}
                className="h-10 w-auto object-contain"
              />

              <button
                type="button"
                onClick={
                  closeMobile
                }
                className="p-1.5 text-brand-brown rounded-lg hover:bg-brand-brown/10 transition-colors"
                aria-label="إغلاق القائمة"
              >
                <MdClose className="w-5 h-5" />
              </button>
            </div>

            <div className="flex flex-col p-3 gap-0.5">

              {/* Mobile Play */}
              <button
                type="button"
                onClick={
                  handlePlayClick
                }
                disabled={
                  openingPlay
                }
                className="flex w-full items-center gap-2 px-4 py-3 rounded-xl text-brand-brown hover:bg-brand-purple/10 hover:text-brand-purple font-semibold text-base transition-all disabled:cursor-wait disabled:opacity-60"
              >
                <NavIcon
                  src="/assets/images/chese.jpeg"
                  alt="إلعب الآن"
                />

                {openingPlay
                  ? 'جاري فتح اللعبة...'
                  : 'إلعب الآن'}
              </button>

              <a
                href={
                  URLS.store
                }
                target="_blank"
                rel="noopener noreferrer"
                onClick={
                  closeMobile
                }
                className="flex items-center gap-2 px-4 py-3 rounded-xl text-brand-brown hover:bg-brand-purple/10 hover:text-brand-purple font-semibold text-base transition-all"
              >
                <NavIcon
                  src="/assets/images/store.jpeg"
                  alt="متجر شطارة"
                />

                متجر شطارة
              </a>

              <a
                href={
                  URLS.club
                }
                target="_blank"
                rel="noopener noreferrer"
                onClick={
                  closeMobile
                }
                className="flex items-center gap-2 px-4 py-3 rounded-xl text-brand-brown hover:bg-brand-purple/10 hover:text-brand-purple font-semibold text-base transition-all"
              >
                <NavIcon
                  src="/assets/images/commuinty.jpeg"
                  alt="نادي شطارة"
                />

                نادي شطارة
              </a>

              <a
                href={
                  URLS.guide
                }
                target="_blank"
                rel="noopener noreferrer"
                onClick={
                  closeMobile
                }
                className="flex items-center gap-2 px-4 py-3 rounded-xl text-brand-brown hover:bg-brand-purple/10 hover:text-brand-purple font-semibold text-base transition-all"
              >
                <NavIcon
                  src="/assets/images/book.jpeg"
                  alt="دليل شطارة"
                />

                دليل شطارة
              </a>

              <hr className="border-brand-brown/10 my-2" />

              {mounted &&
              isLoggedIn ? (
                <button
                  type="button"
                  onClick={() => {
                    logout();
                    closeMobile();
                  }}
                  className="flex items-center justify-center gap-2 px-4 py-3 rounded-xl bg-brand-purple text-white font-bold text-base"
                >
                  <MdLogout className="w-5 h-5" />

                  تسجيل الخروج
                </button>
              ) : (
                <Link
                  href="/login"
                  onClick={
                    closeMobile
                  }
                  className="flex items-center justify-center gap-2 px-4 py-3 rounded-xl bg-brand-purple text-white font-bold text-base"
                >
                  <MdLogin className="w-5 h-5" />

                  تسجيل الدخول
                </Link>
              )}
            </div>
          </div>
        </>
      )}
    </>
  );
}

function NavIcon({
  src,
  alt,
}: {
  src: string;
  alt: string;
}) {
  return (
    <img
      src={src}
      alt={alt}
      className="w-5 h-5 object-contain rounded-sm"
    />
  );
}