'use client';

import Image from 'next/image';
import {
  useCallback,
  useState,
} from 'react';
import { HiPlay } from 'react-icons/hi';

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
          'Preview isLoggedIn:',
          isLoggedIn
        );

        console.log(
          'Preview user:',
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
    <section
      className="bg-white py-[70px]"
      dir="rtl"
    >
      <div className="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <div className="rounded-[24px] bg-[#AB86B9] p-4 shadow-xl sm:p-6">
          <div className="flex flex-col items-stretch overflow-hidden rounded-[16px] bg-white lg:flex-row">

            {/* Board Image Side */}
            <div className="relative aspect-square w-full bg-[#E8DCC4] p-6 lg:min-h-[380px] lg:flex-[2.5] lg:aspect-auto">
              <Image
                src="/assets/images/shatttt.png"
                alt="لوحة شطارة"
                fill
                className="object-contain"
              />
            </div>

            {/* Content Side */}
            <div className="flex w-full flex-col justify-center gap-4 border-t border-gray-100 p-6 text-right sm:p-8 lg:flex-[1] lg:border-l lg:border-t-0">
              <h2 className="text-2xl font-bold leading-snug text-[#6B4E45] sm:text-3xl">
                جرّب لعبة شطارة الآن
              </h2>

              <p className="text-sm font-medium leading-relaxed text-gray-500 sm:text-base">
                لعبة ذهنية استراتيجية تعتمد على بناء القرار وإدارة القوة.
                تحدَّ أصدقاءك والعب مباشرة من متصفحك.
              </p>

              <button
                type="button"
                onClick={handlePlayClick}
                disabled={openingPlay}
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