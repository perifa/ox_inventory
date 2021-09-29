import { useEffect, useRef } from 'react';
import { noop } from '../utils/misc';
import { sendNui } from '../utils/nuiMessage';

type FrameVisibleSetter = (bool: boolean) => void;

const LISTENED_KEYS = ['Escape'];

// Basic hook to listen for key presses in NUI in order to exit
export const useExitListener = (visibleSetter: FrameVisibleSetter) => {
  const setterRef = useRef<FrameVisibleSetter>(noop);

  useEffect(() => {
    setterRef.current = visibleSetter;
  }, [visibleSetter]);

  useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (LISTENED_KEYS.includes(e.code)) {
        setterRef.current(false);
        sendNui('exit');
      }
    };

    window.addEventListener('keyup', keyHandler);

    return () => window.removeEventListener('keyup', keyHandler);
  }, []);
};