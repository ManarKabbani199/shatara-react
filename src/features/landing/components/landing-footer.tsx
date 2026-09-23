'use client';

import Link from 'next/link';
import Image from 'next/image';
import {
  useCallback,
  useState,
} from 'react';

import {
  SITE,
  CONTACT,
  URLS,
  SOCIALS,
} from '@/config/constants';

import {
  FaLinkedin,
  FaXTwitter,
  FaInstagram,
  FaYoutube,
  FaFacebook,
} from 'react-icons/fa6';

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
      name: 'المنتجات',
      href: '#products',
    },
  ],
};

const socials = (
  [
    {
      key: 'linkedin',
      icon: FaLinkedin,
      label: 'LinkedIn',
    },
    {
      key: 'twitter',
      icon: FaXTwitter,
      label: 'X',
    },
    {
      key: 'facebook',
      icon: FaFacebook,
      label: 'Facebook',
    },
    {
      key: 'instagram',
      icon: FaInstagram,
      label: 'Instagram',
    },
    {
      key: 'youtube',
      icon: FaYoutube,
      label: 'YouTube',
    },
  ] as const
)
  .filter(
    ({ key }) =>
      SOCIALS[key].length > 0
  )
  .map(
    ({
      key,
      icon,
      label,
    }) => ({
      icon,
      label,
      href: SOCIALS[key],
    })
  );

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

      const playWindow =
        window.open(
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
          'Footer isLoggedIn:',
          isLoggedIn
        );

        console.log(
          'Footer user:',
          user
        );

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

        if (!userId && !userUid) {
          throw new Error(
            'بيانات المستخدم لا تحتوي على id أو uid.'
          );
        }

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
      className="bg-white border-t border-gray-100 pt-16 pb-8"
      dir="rtl"
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-12 mb-16 items-start">

          {/* Right Column */}
          <div className="text-right">
            <Link
              href="/"
              className="inline-block mb-8"
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
              <h3 className="text-xl font-bold text-gray-800 mb-6">
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
                          className="text-gray-600 hover:text-[#AB86B9] font-bold text-base transition-colors disabled:opacity-60 disabled:cursor-wait"
                        >
                          {openingPlay
                            ? 'جاري فتح اللعبة...'
                            : link.name}
                        </button>
                      ) : (
                        <Link
                          href={link.href}
                          className="text-gray-600 hover:text-[#AB86B9] font-bold text-base transition-colors"
                        >
                          {link.name}
                        </Link>
                      )}
                    </li>
                  )
                )}

                <li>
                  <a
                    href={URLS.store}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="text-gray-600 hover:text-[#AB86B9] font-bold text-base transition-colors"
                  >
                    متجر شطارة
                  </a>
                </li>
              </ul>
            </div>
          </div>

          {/* Left Column */}
          <div className="text-center md:text-left">
            <h3 className="text-xl font-bold text-gray-800 mb-6">
              تواصل معنا
            </h3>

            <div className="space-y-4">
              <p className="text-gray-600 font-medium">
                {CONTACT.email}
              </p>

              <p
                className="text-gray-800 font-bold text-lg"
                dir="ltr"
              >
                {CONTACT.phone}
              </p>

              <div className="pt-4">
                <a
                  href={`mailto:${CONTACT.email}`}
                  className="inline-block px-8 py-3 rounded-xl bg-[#AB86B9] text-white font-bold text-sm hover:bg-[#AB86B9]/90 transition-colors shadow-sm"
                >
                  مركز المساعدة والدعم
                </a>
              </div>

              {socials.length > 0 && (
                <div className="pt-6 space-y-3">
                  <h4 className="text-sm font-bold text-gray-800">
                    حسابات شطارة
                  </h4>

                  <div className="flex items-center justify-center md:justify-start gap-1.5">
                    {socials.map(
                      (social) => (
                        <a
                          key={
                            social.label
                          }
                          href={
                            social.href
                          }
                          target="_blank"
                          rel="noopener noreferrer"
                          aria-label={
                            social.label
                          }
                          className="w-8 h-8 rounded bg-[#AB86B9] text-white flex items-center justify-center hover:bg-[#AB86B9]/90 transition-all"
                        >
                          <social.icon className="w-4 h-4" />
                        </a>
                      )
                    )}
                  </div>
                </div>
              )}
            </div>
          </div>

        </div>

        {/* Bottom Bar */}
        <div className="pt-8 border-t border-gray-100 flex flex-col md:flex-row items-center justify-between gap-4">
          <p className="text-sm font-bold text-gray-500">
            © {new Date().getFullYear()} شطارة. جميع الحقوق محفوظة
          </p>

          <div className="flex items-center gap-8">
            <Link
              href="/terms"
              className="text-sm font-bold text-gray-500 hover:text-[#AB86B9] transition-colors"
            >
              الشروط والأحكام
            </Link>

            <Link
              href="/privacy"
              className="text-sm font-bold text-gray-500 hover:text-[#AB86B9] transition-colors"
            >
              سياسة الملكية الفكرية
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}