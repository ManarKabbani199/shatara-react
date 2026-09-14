'use client';

import Link from 'next/link';
import Image from 'next/image';
import {
  useCallback,
  useState,
} from 'react';

import {
  FaLinkedin,
  FaXTwitter,
  FaInstagram,
  FaYoutube,
  FaFacebook,
} from 'react-icons/fa6';

import {
  SITE,
  CONTACT,
} from '@/config/constants';

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

const footerLinks = {
  pages: [
    {
      name: 'الرئيسية',
      href: '/',
    },
    {
      name: 'تعرف على شطارة',
      href: '#guide',
    },
    {
      name: 'إلعب الآن',
      href: '#',
      playLink: true,
    },
    {
      name: 'من نحن',
      href: '#about',
    },
  ],

  socials: [
    {
      icon: FaLinkedin,
      href: '#',
      label: 'LinkedIn',
    },
    {
      icon: FaXTwitter,
      href: '#',
      label: 'X',
    },
    {
      icon: FaFacebook,
      href: '#',
      label: 'Facebook',
    },
    {
      icon: FaInstagram,
      href: '#',
      label: 'Instagram',
    },
    {
      icon: FaYoutube,
      href: '#',
      label: 'YouTube',
    },
  ],
};

export function LandingFooter() {
  const {
    user,
    isLoggedIn,
  } = useAuth();

  const [openingPlay, setOpeningPlay] =
    useState(false);

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
          playWindow.location.href = url;
        } else {
          window.location.href = url;
        }
      };

      try {
        console.log(
          'Footer isLoggedIn:',
          isLoggedIn
        );

        console.log(
          'Footer user:',
          user
        );

        /*
         * المستخدم غير مسجل:
         * يفتح اللعبة كزائر.
         */
        if (!isLoggedIn) {
          openPlayPage(PLAY_URL);
          return;
        }

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
          'Footer User ID:',
          userId
        );

        console.log(
          'Footer User UID:',
          userUid
        );

        console.log(
          'Footer User Name:',
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
          'Footer create token status:',
          response.status
        );

        console.log(
          'Footer create token response:',
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
          'Footer final play URL:',
          playUrl
        );

        openPlayPage(playUrl);
      } catch (error) {
        console.error(
          'خطأ فتح اللعبة من Footer:',
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
      getAuthenticatedUser,
      isLoggedIn,
      openingPlay,
      user,
    ]);

  return (
    <footer
      className="border-t border-gray-100 bg-white pb-8 pt-16"
      dir="rtl"
    >
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">

        <div className="mb-16 grid grid-cols-1 items-start gap-12 md:grid-cols-3">

          {/* Right Column */}
          <div className="text-right">
            <Link
              href="/"
              className="mb-8 inline-block"
            >
              <Image
                src="/assets/images/logoapp.png"
                alt={SITE.name}
                width={150}
                height={60}
                className="h-14 w-auto"
              />
            </Link>

            <div className="space-y-4">
              <h3 className="mb-6 text-xl font-bold text-gray-800">
                الصفحات
              </h3>

              <ul className="space-y-4">
                {footerLinks.pages.map(
                  (link) => (
                    <li key={link.name}>
                      {link.playLink ? (
                        <button
                          type="button"
                          onClick={
                            handlePlayClick
                          }
                          disabled={
                            openingPlay
                          }
                          className="text-base font-bold text-gray-600 transition-colors hover:text-[#AB86B9] disabled:cursor-wait disabled:opacity-60"
                        >
                          {openingPlay
                            ? 'جاري فتح اللعبة...'
                            : link.name}
                        </button>
                      ) : (
                        <Link
                          href={link.href}
                          className="text-base font-bold text-gray-600 transition-colors hover:text-[#AB86B9]"
                        >
                          {link.name}
                        </Link>
                      )}
                    </li>
                  )
                )}
              </ul>
            </div>
          </div>

          {/* Middle Column */}
          <div className="text-center">
            <h3 className="mb-6 text-xl font-bold text-gray-800">
              تواصل معنا
            </h3>

            <div className="space-y-4">
              <p className="font-medium text-gray-600">
                {CONTACT.email}
              </p>

              <p
                className="text-lg font-bold text-gray-800"
                dir="ltr"
              >
                {CONTACT.phone}
              </p>

              <div className="pt-4">
                <button
                  type="button"
                  className="rounded-xl bg-[#AB86B9] px-8 py-3 text-sm font-bold text-white shadow-sm transition-colors hover:bg-[#AB86B9]/90"
                >
                  مركز المساعدة والدعم
                </button>
              </div>
            </div>
          </div>

          {/* Left Column */}
          <div className="rounded-[24px] bg-[#F8F9FA] p-5 sm:p-8">
            <h3 className="mb-4 text-right text-[15px] font-bold text-[#4A4A4A]">
              ابق مطلع على جديد شطارة
            </h3>

            <form
              className="mb-10 flex flex-col gap-[10px] sm:flex-row"
              dir="rtl"
              onSubmit={(event) =>
                event.preventDefault()
              }
            >
              <input
                type="email"
                placeholder="البريد الإلكتروني"
                className="w-full rounded-lg border border-gray-200 bg-white px-4 py-3 text-right text-sm transition-all placeholder:text-gray-300 focus:border-[#AB86B9] focus:outline-none"
              />

              <button
                type="submit"
                className="w-full whitespace-nowrap rounded-lg bg-[#AB86B9] px-4 py-3 text-sm font-bold text-white shadow-sm transition-all hover:bg-[#AB86B9]/90 sm:w-auto"
              >
                إشترك الآن
              </button>
            </form>

            <div className="space-y-3 text-right">
              <h4 className="text-[13px] font-bold text-[#4A4A4A]">
                حسابات شطارة
              </h4>

              <div className="flex items-center justify-start gap-2">
                {footerLinks.socials.map(
                  (social) => (
                    <Link
                      key={
                        social.label
                      }
                      href={
                        social.href
                      }
                      aria-label={
                        social.label
                      }
                      className="flex h-10 w-10 items-center justify-center rounded bg-[#AB86B9] text-white transition-all hover:bg-[#AB86B9]/90"
                    >
                      <social.icon className="h-5 w-5" />
                    </Link>
                  )
                )}
              </div>
            </div>
          </div>

        </div>

        {/* Bottom Bar */}
        <div className="flex flex-col items-center justify-between gap-4 border-t border-gray-100 pt-8 md:flex-row">
          <p className="text-sm font-bold text-gray-500">
            © 2025 شطارة. جميع الحقوق محفوظة
          </p>

          <div className="flex items-center gap-8">
            <Link
              href="/terms"
              className="text-sm font-bold text-gray-500 transition-colors hover:text-[#AB86B9]"
            >
              الشروط والأحكام
            </Link>

            <Link
              href="/privacy"
              className="text-sm font-bold text-gray-500 transition-colors hover:text-[#AB86B9]"
            >
              سياسة الملكية الفكرية
            </Link>
          </div>
        </div>

      </div>
    </footer>
  );
}