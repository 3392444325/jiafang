/** @type {import('tailwindcss').Config} */
export default {
  content: [
    './index.html',
    './src/**/*.{vue,js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      // ST.KELLY 色彩系统 — 低饱和大地色 + 香槟金
      colors: {
        linen: '#f7f3ec',
        ivory: '#fbf9f4',
        sand: '#efe7da',
        clay: '#d9c7b2',
        gold: '#b39b6b',
        'gold-deep': '#7d6634',
        ink: '#1c1b19',
        'ink-soft': '#55514a',
        mist: '#a8b4bc',
      },
      // 字体：衬线展示体 + 无衬线正文
      fontFamily: {
        // 展示衬线：西文 Didot/Bodoni，中文走思源宋体 webfont，再回退本机宋体
        display: ['"Didot"', '"Bodoni MT"', '"Noto Serif SC"', '"Songti SC"', '"STSong"', '"STZhongsong"', '"SimSun"', 'Georgia', 'serif'],
        body: ['"PingFang SC"', '"Microsoft YaHei"', '"Segoe UI"', 'system-ui', 'sans-serif'],
      },
      animation: {
        'fade-up': 'fade-up 0.9s cubic-bezier(0.22, 1, 0.36, 1) both',
        'fade-in': 'fade-in 1.2s ease both',
        kenburns: 'kenburns 14s ease-out both',
      },
      keyframes: {
        'fade-up': {
          from: { opacity: '0', transform: 'translateY(28px)' },
          to: { opacity: '1', transform: 'none' },
        },
        'fade-in': {
          from: { opacity: '0' },
          to: { opacity: '1' },
        },
        kenburns: {
          from: { transform: 'scale(1)' },
          to: { transform: 'scale(1.08)' },
        },
      },
    },
  },
  plugins: [],
}
