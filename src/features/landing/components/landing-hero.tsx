'use client';

import Image from 'next/image';
import {
  useCallback,
  useState,
} from 'react';

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

export function LandingHero() {
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
          playWindow.location.href = url;
        } else {
          window.location.href = url;
        }
      };

      try {
        console.log(
          'Hero isLoggedIn:',
          isLoggedIn
        );

        console.log(
          'Hero user:',
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
          'Hero final play URL:',
          playUrl
        );

        openPlayPage(playUrl);
      } catch (error) {
        console.error(
          'خطأ فتح اللعبة من Hero:',
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

  return (
    <section
      className="relative pt-12 pb-16 overflow-hidden bg-white"
      dir="rtl"
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-20">
        <div className="text-center space-y-6 anim-fade-up">

          {/* Saudi Patent Badge */}
          <div className="inline-flex items-center px-2 py-1 bg-white text-[#06AC2A] border border-[#06AC2A] shadow-sm">
            <span className="text-[13px] font-bold">
              براءة اختراع سعودية
            </span>

            <div className="mr-2 w-5 h-4 bg-[#06AC2A] flex items-center justify-center">
              <span className="text-[8px] text-white font-bold">
                SA
              </span>
            </div>
          </div>

          {/* Heading */}
          <h1 className="text-4xl md:text-[52px] font-bold text-[#6B4E45] leading-[1.2] max-w-5xl mx-auto tracking-tight">
            المعركة بدأت، وجيشك بانتظار أوامرك
          </h1>

          {/* Description */}
          <div className="max-w-2xl mx-auto">
            <p className="text-lg text-gray-500 font-medium leading-relaxed">
              اختبر شطارتك في أقوى تجربة شطارة عالمية ومجتمع متكامل
              <br className="hidden md:block" />
              للتواصل معه.
            </p>
          </div>

          {/* CTA Button */}
          <div className="flex justify-center pt-4">
            <button
              type="button"
              onClick={handlePlayClick}
              disabled={openingPlay}
              className="flex items-center gap-3 px-8 py-3 bg-[#AB86B9] text-white text-lg font-bold shadow hover:bg-[#AB86B9]/90 transition-all rounded-xl disabled:opacity-60 disabled:cursor-wait"
            >
              <Image
                src="/assets/images/Group.png"
                alt="شعار اللعب"
                width={20}
                height={20}
                className="w-5 h-5 object-contain"
              />

              <span>
                {openingPlay
                  ? 'جاري فتح اللعبة...'
                  : 'إلعب الآن'}
              </span>
            </button>
          </div>
        </div>
      </div>

      {/* Hero Image Area */}
      <div className="relative w-full h-[320px] sm:h-[420px] md:h-[750px] lg:h-[850px] -mt-12 sm:-mt-16 md:-mt-32 lg:-mt-40 anim-fade-up">

        {/* Subtle Edge Overlays */}
        <div className="absolute inset-0 z-10 pointer-events-none">

          {/* Top fade */}
          <div className="absolute inset-x-0 top-0 h-32 bg-gradient-to-b from-white to-transparent" />

          {/* Bottom fade */}
          <div className="absolute inset-x-0 bottom-0 h-20 bg-gradient-to-t from-white to-transparent" />

          {/* Side fades */}
          <div className="absolute inset-y-0 left-0 w-24 md:w-48 bg-gradient-to-r from-white to-transparent" />

          <div className="absolute inset-y-0 right-0 w-24 md:w-48 bg-gradient-to-l from-white to-transparent" />

        </div>

        <div className="relative w-full h-full">
          <Image
            src="/assets/images/looog.webp"
            alt="شطارة"
            fill
            className="object-contain object-center"
            priority
          />
        </div>
      </div>
    </section>
  );
}