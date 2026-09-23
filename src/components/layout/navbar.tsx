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

  const getAuthenticatedUser =
    useCallback((): AuthUserData | null => {
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
          'Navbar isLoggedIn:',
          isLoggedIn
        );

        console.log(
          'Navbar user:',
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
          'Navbar User ID:',
          userId
        );

        console.log(
          'Navbar User UID:',
          userUid
        );

        console.log(
          'Navbar User Name:',
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
          'Navbar create token status:',
          response.status
        );

        console.log(
          'Navbar create token response:',
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
          'Navbar final play URL:',
          playUrl
        );

        openPlayPage(playUrl);
      } catch (error) {
        console.error(
          'خطأ فتح اللعبة من Navbar:',
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
          window.alert(message);
        }
      } finally {
        setOpeningPlay(false);
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
        className="sticky top-0 z-50 w-full border-b border-gray-100 bg-white"
        style={{
          willChange:
            'transform',
        }}
      >
        <nav
          className="mx-auto max-w-7xl px-4 py-4"
          dir="rtl"
        >
          {/* Desktop */}
          <div className="hidden w-full items-center justify-between lg:flex">
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
                onClick={handlePlayClick}
                disabled={openingPlay}
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
                href={URLS.store}
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
                href={URLS.club}
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
                href={URLS.guide}
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

            <div className="flex shrink-0 items-center gap-3">
              {mounted &&
              isLoggedIn ? (
                <button
                  type="button"
                  onClick={logout}
                  className="flex items-center gap-1.5 rounded-xl bg-brand-purple/10 px-6 py-2 text-base font-bold text-brand-purple transition-colors hover:bg-brand-purple hover:text-white"
                >
                  <MdLogout className="h-5 w-5" />
                  تسجيل الخروج
                </button>
              ) : (
                <Link
                  href="/login"
                  className="flex items-center justify-center rounded-xl px-8 py-2 text-lg font-bold text-white shadow transition-all hover:opacity-90"
                  style={{
                    backgroundColor:
                      '#AB86B9',
                  }}
                >
                  <MdLogin className="ml-1.5 h-5 w-5" />
                  تسجيل الدخول
                </Link>
              )}
            </div>
          </div>

          {/* Mobile Header */}
          <div className="flex items-center justify-between lg:hidden">
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
                className="h-6 w-6"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
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
            className="fixed inset-0 z-50 bg-black/50"
            onClick={
              closeMobile
            }
          />

          <div
            className="fixed inset-y-0 start-0 z-50 flex w-72 max-w-[85vw] flex-col bg-white shadow-2xl"
            dir="rtl"
          >
            <div className="flex shrink-0 items-center justify-between border-b border-brand-brown/10 p-4">
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
                className="rounded-lg p-2 text-brand-brown transition-colors hover:bg-brand-brown/10"
                aria-label="إغلاق القائمة"
              >
                <MdClose className="h-6 w-6" />
              </button>
            </div>

            <div className="flex flex-col gap-1 overflow-y-auto p-4">

              {/* Mobile Play */}
              <button
                type="button"
                onClick={
                  handlePlayClick
                }
                disabled={
                  openingPlay
                }
                className="flex w-full items-center gap-2 rounded-xl px-4 py-3 text-right text-base font-semibold text-brand-brown transition-all hover:bg-brand-purple/10 hover:text-brand-purple disabled:cursor-wait disabled:opacity-60"
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
                href={URLS.store}
                target="_blank"
                rel="noopener noreferrer"
                onClick={
                  closeMobile
                }
                className="flex items-center gap-2 rounded-xl px-4 py-3 text-base font-semibold text-brand-brown transition-all hover:bg-brand-purple/10 hover:text-brand-purple"
              >
                <NavIcon
                  src="/assets/images/store.jpeg"
                  alt="متجر شطارة"
                />

                متجر شطارة
              </a>

              <a
                href={URLS.club}
                target="_blank"
                rel="noopener noreferrer"
                onClick={
                  closeMobile
                }
                className="flex items-center gap-2 rounded-xl px-4 py-3 text-base font-semibold text-brand-brown transition-all hover:bg-brand-purple/10 hover:text-brand-purple"
              >
                <NavIcon
                  src="/assets/images/commuinty.jpeg"
                  alt="نادي شطارة"
                />

                نادي شطارة
              </a>

              <a
                href={URLS.guide}
                target="_blank"
                rel="noopener noreferrer"
                onClick={
                  closeMobile
                }
                className="flex items-center gap-2 rounded-xl px-4 py-3 text-base font-semibold text-brand-brown transition-all hover:bg-brand-purple/10 hover:text-brand-purple"
              >
                <NavIcon
                  src="/assets/images/book.jpeg"
                  alt="دليل شطارة"
                />

                دليل شطارة
              </a>

              <hr className="my-2 border-brand-brown/10" />

              {mounted &&
              isLoggedIn ? (
                <button
                  type="button"
                  onClick={() => {
                    logout();
                    closeMobile();
                  }}
                  className="flex items-center justify-center gap-2 rounded-xl bg-brand-purple px-4 py-3 text-base font-bold text-white"
                >
                  <MdLogout className="h-5 w-5" />
                  تسجيل الخروج
                </button>
              ) : (
                <Link
                  href="/login"
                  onClick={
                    closeMobile
                  }
                  className="flex items-center justify-center gap-2 rounded-xl bg-brand-purple px-4 py-3 text-base font-bold text-white"
                >
                  <MdLogin className="h-5 w-5" />
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
      className="h-5 w-5 rounded-sm object-contain"
    />
  );
}