'use strict';

{
  // ■Language (Drop Down List)
  const languageDDList = document.querySelector('.language .dropdown-list');

  document.addEventListener('click', (e) => {
    if(e.target.closest('.language')) {
      languageDDList.classList.toggle('show');
    } else {
      languageDDList.classList.remove('show');
    }
  });

  // ■Carousel
  const mobileNext = document.querySelector('.mobile .next');
  const desktopNext = document.querySelector('.desktop .next');
  const mobilePrev = document.querySelector('.mobile .prev')
  const desktopPrev = document.querySelector('.desktop .prev')
  const mobileUl = document.querySelector('.carousel.mobile ul');  
  const desktopUl = document.querySelector('.carousel.desktop ul');  
  const mobileSlides = mobileUl.children;
  const desktopSlides = desktopUl.children;
  const mobileDots = [];
  const desktopDots = [];
  let currentIndex = 0;
  
  function updateMobileButton() {
    mobilePrev.classList.remove('hidden');
    mobileNext.classList.remove('hidden');
    if (currentIndex === 0) {
      mobilePrev.classList.add('hidden');
    }
    if (currentIndex === mobileSlides.length - 1) {
      mobileNext.classList.add('hidden');
    }
  }

  function updateDesktopButton() {
    desktopPrev.classList.remove('hidden');
    desktopNext.classList.remove('hidden');
    if (currentIndex === 0) {
      desktopPrev.classList.add('hidden');
    }
    if (currentIndex === desktopSlides.length - 1) {
      desktopNext.classList.add('hidden');
    }
  }

  function moveMobileSlides() {
    const mobileSlideWidth = mobileSlides[0].getBoundingClientRect().width;
    mobileUl.style.transform = `translateX(${-1 * mobileSlideWidth * currentIndex}px)`;
  }

  function moveDesktopSlides() {
    const desktopSlideWidth = desktopSlides[0].getBoundingClientRect().width;
    desktopUl.style.transform = `translateX(${-1 * desktopSlideWidth * currentIndex}px)`;
  }

  function setupMobileDots() {
    // ドットの初期化（ブラウザバックへの対応）
    if(document.querySelectorAll('.carousel.mobile nav button').length !== 0) {
      document.querySelectorAll('.carousel.mobile nav button').forEach(button => {
        button.remove();
      })
    }
    for  (let i = 0; i < mobileSlides.length; i++) {  
      const button = document.createElement('button');
      button.addEventListener('click', () => {
        currentIndex = i; // i番目のボタンがクリックされたから   
        updateMobileDots();         
        updateMobileButton();
        moveMobileSlides();
      });
      mobileDots.push(button);
      document.querySelector('.carousel.mobile nav').appendChild(button);      
    }
    mobileDots[0].classList.add('current');
  }

  function setupDesktopDots() {
    // ドットの初期化（ブラウザバックへの対応）
    if(document.querySelectorAll('.carousel.desktop nav button').length !== 0) {
      document.querySelectorAll('.carousel.desktop nav button').forEach(button => {
        button.remove();
      })
    }
    for  (let i = 0; i < desktopSlides.length; i++) {
      const button = document.createElement('button');
      button.addEventListener('click', () => {
        currentIndex = i; // i番目のボタンがクリックされたから
        updateDesktopDots();
        updateDesktopButton();
        moveDesktopSlides();
      });
      desktopDots.push(button);
      document.querySelector('.carousel.desktop nav').appendChild(button);      
    }
    desktopDots[0].classList.add('current');
  }

  function updateMobileDots() {
    mobileDots.forEach(dot => {
      dot.classList.remove('current');
    });
    mobileDots[currentIndex].classList.add('current');
  }

  function updateDesktopDots() {
    desktopDots.forEach(dot => {
      dot.classList.remove('current');
    });
    desktopDots[currentIndex].classList.add('current');
  }

  updateMobileButton();
  updateDesktopButton();
  setupMobileDots();
  setupDesktopDots();

  mobileNext.addEventListener('click', () => {
        currentIndex++;
        updateMobileButton();
        updateMobileDots();
        moveMobileSlides();
    });

  desktopNext.addEventListener('click', () => {
        currentIndex++;
        updateDesktopButton();
        updateDesktopDots();
        moveDesktopSlides();
    });

    mobilePrev.addEventListener('click', () => {
        currentIndex--;
        updateMobileButton();
        updateMobileDots();
        moveMobileSlides();
    });
    
    desktopPrev.addEventListener('click', () => {
        currentIndex--;
        updateDesktopButton();
        updateDesktopDots();
        moveDesktopSlides();
    });
}
