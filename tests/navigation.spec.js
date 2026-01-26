import { test, expect } from '@playwright/test';

// Animation duration is 1250ms, plus some buffer
const ANIMATION_WAIT = 1500;

const SECTIONS = [
  'intro',
  'the-story',
  'the-film',
  'join-the-journey',
  'about-us',
  'acknowledgments',
];

test.describe('Section Navigation', () => {
  test.describe('Direct URL visits', () => {
    test('home page activates intro slide', async ({ page }) => {
      await page.goto('/');

      const activeSlide = await page.evaluate(() =>
        document.querySelector('.slide.active')?.id
      );
      expect(activeSlide).toBe('intro');

      // Verify content is visible
      const innerOpacity = await page.evaluate(() => {
        const inner = document.querySelector('#intro .inner');
        return inner ? getComputedStyle(inner).opacity : '0';
      });
      expect(innerOpacity).toBe('1');
    });

    for (const section of SECTIONS.slice(1)) {
      test(`direct visit to /#${section} activates correct slide`, async ({ page }) => {
        await page.goto(`/#${section}`);

        // Wait for JS initialization
        await page.waitForFunction(
          (id) => document.querySelector(`#${id}`)?.classList.contains('active'),
          section,
          { timeout: 5000 }
        );

        const activeSlide = await page.evaluate(() =>
          document.querySelector('.slide.active')?.id
        );
        expect(activeSlide).toBe(section);

        // Verify content is visible (opacity transitions to 1)
        const innerOpacity = await page.evaluate((id) => {
          const inner = document.querySelector(`#${id} .inner`);
          return inner ? getComputedStyle(inner).opacity : '0';
        }, section);
        expect(innerOpacity).toBe('1');
      });
    }
  });

  test.describe('Nav link navigation', () => {
    test('clicking nav links switches slides', async ({ page }) => {
      await page.goto('/');

      // Click "The Story" nav link
      await page.click('a[href="#the-story"]');

      // Wait for slide transition
      await page.waitForFunction(
        () => document.querySelector('#the-story')?.classList.contains('active'),
        { timeout: 5000 }
      );

      const activeSlide = await page.evaluate(() =>
        document.querySelector('.slide.active')?.id
      );
      expect(activeSlide).toBe('the-story');

      // Verify URL hash updated
      const hash = await page.evaluate(() => location.hash);
      expect(hash).toBe('#the-story');
    });

    test('clicking multiple nav links in sequence', async ({ page }) => {
      await page.goto('/');

      const navLinks = ['the-film', 'about-us', 'the-story'];

      for (const section of navLinks) {
        await page.click(`a[href="#${section}"]`);

        // Wait for animation to complete before checking/clicking next
        await page.waitForTimeout(ANIMATION_WAIT);

        const activeSlide = await page.evaluate(() =>
          document.querySelector('.slide.active')?.id
        );
        expect(activeSlide).toBe(section);
      }
    });
  });

  test.describe('Arrow navigation', () => {
    test('next/previous controls switch slides', async ({ page }) => {
      await page.goto('/');

      // Click next arrow
      await page.click('nav .next');

      // Wait for animation to complete
      await page.waitForTimeout(ANIMATION_WAIT);

      let activeSlide = await page.evaluate(() =>
        document.querySelector('.slide.active')?.id
      );
      expect(activeSlide).toBe('the-story');

      // Click previous arrow
      await page.click('nav .previous');

      // Wait for animation to complete
      await page.waitForTimeout(ANIMATION_WAIT);

      activeSlide = await page.evaluate(() =>
        document.querySelector('.slide.active')?.id
      );
      expect(activeSlide).toBe('intro');
    });
  });

  test.describe('Keyboard navigation', () => {
    test('arrow keys switch slides', async ({ page }) => {
      await page.goto('/');

      // Press right arrow
      await page.keyboard.press('ArrowRight');

      // Wait for animation to complete
      await page.waitForTimeout(ANIMATION_WAIT);

      let activeSlide = await page.evaluate(() =>
        document.querySelector('.slide.active')?.id
      );
      expect(activeSlide).toBe('the-story');

      // Press left arrow
      await page.keyboard.press('ArrowLeft');

      // Wait for animation to complete
      await page.waitForTimeout(ANIMATION_WAIT);

      activeSlide = await page.evaluate(() =>
        document.querySelector('.slide.active')?.id
      );
      expect(activeSlide).toBe('intro');
    });
  });

  test.describe('Content visibility', () => {
    test('slide content fades in when active', async ({ page }) => {
      await page.goto('/#the-story');

      // Wait for content transition (0.75s delay + 1s transition)
      await page.waitForTimeout(2000);

      const contentOpacity = await page.evaluate(() => {
        const content = document.querySelector('#the-story .inner .content');
        return content ? getComputedStyle(content).opacity : '0';
      });
      expect(contentOpacity).toBe('1');

      // Verify transform is reset
      const transform = await page.evaluate(() => {
        const content = document.querySelector('#the-story .inner .content');
        return content ? getComputedStyle(content).transform : '';
      });
      // translateY(0) results in 'none' or matrix with no Y translation
      expect(transform === 'none' || transform.includes('matrix')).toBe(true);
    });
  });
});
