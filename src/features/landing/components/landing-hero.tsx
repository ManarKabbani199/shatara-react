'use client';

import Image from 'next/image';
import { useCallback, useState } from 'react';
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
  const { user, isLoggedIn } = useAuth();

  const [openingPlay, setOpeningPlay] =
    useState(false);

  const getAuthenticatedUser =
    useCallback((): AuthUserData | null => {
      /*
       * أولًا: بيانات useAuth
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
       * ثانيًا: localStorage كحل احتياطي
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

      /*
       * فتح التبويب فور الضغط
       * حتى لا يمنع المتصفح Popup.
       */
      const playWindow = window.open(
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
          playWindow.location.href = url;
        } else {
          window.location.href = url;
        }
      };

      const showError = (
        message: string
      ) => {
        if (!playWindow) {
          window.alert(message);
          return;
        }

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

        /*
         * الزائر
         */
        if (!isLoggedIn) {
          console.log(
            'فتح اللعبة كزائر'
          );

          openPlayPage(PLAY_URL);
          return;
        }

        /*
         * المستخدم المسجل
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
          'Hero User ID:',
          userId
        );

        console.log(
          'Hero User UID:',
          userUid
        );

        console.log(
          'Hero User Name:',
          authUser.name
        );

        if (!userId && !userUid) {
          throw new Error(
            'بيانات المستخدم لا تحتوي على id أو uid.'
          );
        }

        /*
         * إنشاء Token
         */
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
          'Hero create token status:',
          response.status
        );

        console.log(
          'Hero create token response:',
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
         * إرسال Token إلى Flutter
         */
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

        showError(message);
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
      className="relative overflow-hidden bg-white pb-16 pt-12"
      dir="rtl"
    >
      <div className="relative z-20 mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="anim-fade-up space-y-6 text-center">

          {/* Saudi Patent Badge */}
          <div className="inline-flex items-center border border-[#4A8564] bg-white px-2 py-1 text-[#4A8564] shadow-sm">
            <span className="text-[13px] font-bold">
              براءة اختراع سعودية
            </span>

            <div className="mr-2 flex h-4 w-5 items-center justify-center bg-[#4A8564]">
              <span className="text-[8px] font-bold text-white">
                SA
              </span>
            </div>
          </div>

          {/* Heading */}
          <h1 className="mx-auto max-w-5xl text-3xl font-bold leading-[1.2] tracking-tight text-[#644B48] sm:text-4xl md:text-[52px]">
            المعركة بدأت، وجيشك بانتظار أوامرك
          </h1>

          {/* Description */}
          <div className="mx-auto max-w-2xl">
            <p className="text-lg font-medium leading-relaxed text-gray-500">
              اختبر شطارتك في أقوى تجربة شطارة عالمية ومجتمع متكامل
              <br className="hidden md:block" />
              للتواصل معه.
            </p>
          </div>

          {/* Play Button */}
          <div className="flex justify-center pt-4">
            <button
              type="button"
              onClick={handlePlayClick}
              disabled={openingPlay}
              className="flex items-center gap-3 rounded-xl bg-[#AB86B9] px-6 py-2.5 text-base font-bold text-white shadow transition-all hover:bg-[#AB86B9]/90 disabled:cursor-wait disabled:opacity-60 sm:px-8 sm:py-3 sm:text-lg"
            >
              <Image
                src="/assets/images/Group.png"
                alt="شعار اللعب"
                width={20}
                height={20}
                className="h-5 w-5 object-contain"
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

      {/* Hero Image */}
      <div className="anim-fade-up relative -mt-12 h-[320px] w-full sm:-mt-16 sm:h-[420px] md:-mt-32 md:h-[750px] lg:-mt-40 lg:h-[850px]">

        <div className="pointer-events-none absolute inset-0 z-10">

          <div className="absolute inset-x-0 top-0 h-32 bg-gradient-to-b from-white to-transparent" />

          <div className="absolute inset-x-0 bottom-0 h-20 bg-gradient-to-t from-white to-transparent" />

          <div className="absolute inset-y-0 left-0 w-24 bg-gradient-to-r from-white to-transparent md:w-48" />

          <div className="absolute inset-y-0 right-0 w-24 bg-gradient-to-l from-white to-transparent md:w-48" />

        </div>

        <div className="relative h-full w-full">
          <Image
            src="/assets/images/looog.png"
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