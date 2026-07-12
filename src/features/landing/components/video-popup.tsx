'use client';

import { useEffect, useRef, useState, useCallback } from 'react';

const SESSION_KEY = 'shatara_kings_intro_seen';

export function VideoPopup() {
  const [visible, setVisible] = useState(false);
  const [animOut, setAnimOut] = useState(false);
  const videoRef = useRef<HTMLVideoElement>(null);
  const overlayRef = useRef<HTMLDivElement>(null);

  /* Show popup on first visit of this session */
  useEffect(() => {
    if (typeof window === 'undefined') return;
    const alreadySeen = sessionStorage.getItem(SESSION_KEY);
    if (!alreadySeen) {
      // Small delay so the page renders first
      const timer = setTimeout(() => setVisible(true), 600);
      return () => clearTimeout(timer);
    }
  }, []);

  /* Autoplay the video once the popup is shown */
  useEffect(() => {
    if (!visible) return;
    const video = videoRef.current;
    if (!video) return;
    video.muted = true;
    video.play().catch(() => {
      /* Autoplay blocked — video stays paused, user can press play */
    });
  }, [visible]);

  const closePopup = useCallback(() => {
    setAnimOut(true);
    videoRef.current?.pause();
    // Wait for exit animation then unmount
    setTimeout(() => {
      setVisible(false);
      setAnimOut(false);
      sessionStorage.setItem(SESSION_KEY, '1');
    }, 350);
  }, []);

  /* Close on backdrop click */
  const handleOverlayClick = useCallback(
    (e: React.MouseEvent<HTMLDivElement>) => {
      if (e.target === overlayRef.current) closePopup();
    },
    [closePopup],
  );

  /* Close on Escape key */
  useEffect(() => {
    if (!visible) return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === 'Escape') closePopup();
    };
    window.addEventListener('keydown', onKey);
    return () => window.removeEventListener('keydown', onKey);
  }, [visible, closePopup]);

  /* Lock body scroll while open */
  useEffect(() => {
    if (visible) {
      document.body.style.overflow = 'hidden';
    } else {
      document.body.style.overflow = '';
    }
    return () => {
      document.body.style.overflow = '';
    };
  }, [visible]);

  if (!visible) return null;

  return (
    /* ── Backdrop ── */
    <div
      ref={overlayRef}
      onClick={handleOverlayClick}
      aria-modal="true"
      role="dialog"
      aria-label="فيديو تعريفي"
      className={`video-popup-overlay ${animOut ? 'video-popup-overlay--out' : 'video-popup-overlay--in'}`}
      style={{ zIndex: 9999 }}
    >
      {/* ── Modal card ── */}
      <div
        className={`video-popup-card ${animOut ? 'video-popup-card--out' : 'video-popup-card--in'}`}
      >
        {/* Close button */}
        <button
          onClick={closePopup}
          aria-label="إغلاق"
          className="video-popup-close"
          type="button"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth={2.5}
            strokeLinecap="round"
            strokeLinejoin="round"
            aria-hidden="true"
            width={18}
            height={18}
          >
            <line x1="18" y1="6" x2="6" y2="18" />
            <line x1="6" y1="6" x2="18" y2="18" />
          </svg>
        </button>

        {/* Video */}
        <div className="video-popup-video-wrapper">
          <video
            ref={videoRef}
            src="/assets/videos/ismall.mp4"
            controls
            muted
            playsInline
            loop={false}
            preload="metadata"
            className="video-popup-video"
          />
        </div>

        {/* Footer label */}
        <div className="video-popup-footer" dir="rtl">
          <span className="video-popup-dot" aria-hidden="true" />
          <p className="video-popup-label">شاهد كيف تبدأ رحلتك في عالم الشطارة</p>
        </div>
      </div>
    </div>
  );
}
