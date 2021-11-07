'use strict';

{
  // ■Search Form
  const searchForm = document.querySelector('.search-form');

  // クリックした時のデザイン
  searchForm.addEventListener('focus', () => {
    searchForm.style.background = 'white';
    searchForm.style.border = '1px solid rgba(0, 0, 0, 0.07)';
  }, true);
  // 別の場所をクリックした時のデザイン
  searchForm.addEventListener('blur', () => {
    searchForm.style.background = 'rgb(235, 235, 235)';
    searchForm.style.border = 'none';
  }, true);

  // ■Account (Drop Down List)
  const accountDDListMobile = document.querySelectorAll('.account .dropdown-list')[1];
  const accountDDListDesktop = document.querySelectorAll('.account .dropdown-list')[0];

  // Mobile MenuのDrop Down Listの挙動
  document.addEventListener('click', (e) => {
    if(e.target.closest('.account')) {
      accountDDListMobile.classList.toggle('show');
    } else {
      accountDDListMobile.classList.remove('show');
    }
  });
  // Desktop MenuのDrop Down Listの挙動
  document.addEventListener('click', (e) => {
    if(e.target.closest('.account')) {
      accountDDListDesktop.classList.toggle('show');
    } else {
      accountDDListDesktop.classList.remove('show');
    }
  });

  // ■Menu: クリックしたメニューにactiveクラスを付ける
  const mobileMenuLists = document.querySelectorAll('.menu.mobile .menu-list li');
  const desktopMenuLists = document.querySelectorAll('.menu.desktop .menu-list li');

  mobileMenuLists.forEach(clickedItem => {
    clickedItem.addEventListener('click', () => {
      mobileMenuLists.forEach(activatedItem => {
        activatedItem.classList.remove('active');
      });
      clickedItem.classList.add('active');
    });
  });

  desktopMenuLists.forEach(clickedItem => {
    clickedItem.addEventListener('click', () => {
      desktopMenuLists.forEach(activatedItem => {
        activatedItem.classList.remove('active');
      });
      clickedItem.classList.add('active');
    });
  });

  // ■Mobile menu
  const mobileMenu = document.querySelector('.menu.mobile');
  const openMobileMenu = document.getElementById('open-mobile-menu');
  const closeMobileMenu = document.getElementById('close-mobile-menu');
  const maskMobileMenu = document.getElementById('mask-mobile-menu');
  const mobileEditGroupIcons = document.querySelectorAll('.menu.mobile .group .edit-icon');
  const mobileGroupLists = document.querySelectorAll('.menu.mobile .group');
  const mobileHome = document.querySelector('.menu.mobile .home');

  // ハンバーガーメニューをクリック => Mobile Menuが開く
  openMobileMenu.addEventListener('click', () => {
    mobileMenu.classList.add('show');
    maskMobileMenu.classList.remove('hidden');
  });
  // ×のアイコンをクリック => Mobile Menuが閉じる
  closeMobileMenu.addEventListener('click', () => {
    mobileMenu.classList.remove('show');
    maskMobileMenu.classList.add('hidden');
  });
  // マスクをクリック => Mobile Menuが閉じる
  maskMobileMenu.addEventListener('click', () => {
    closeMobileMenu.click();
  });
  // Mobile Menuのグループをクリック => クリックしたグループのedit-iconのhiddenクラスを取る
  mobileGroupLists.forEach(list => {
    list.addEventListener('click', () => {
      mobileEditGroupIcons.forEach(icon => {
        icon.classList.add('hidden');
      });
      const clickedListIcon = list.lastElementChild;
      clickedListIcon.classList.remove('hidden');
    });
  });
  // Mobile Menuのホームをクリック => => edit-iconのhiddenクラスを付与
  mobileHome.addEventListener('click', () => {
    mobileEditGroupIcons.forEach(icon => {
      icon.classList.add('hidden');
    });
  });

   // ■addGroup, addLink
  const addGroup = document.getElementById('add-group');
  const addGroupInput = document.querySelectorAll('#add-group input');
  const addLink = document.getElementById('add-link');
  const addLinkInput = document.querySelectorAll('#add-link input');

  // addGroupをクリックしたら、入力欄を表示
  // addGroup以外をクリックしたら、入力欄を非表示
  document.addEventListener('click', (e) => {
    addGroupInput.forEach(input => {
        if(e.target.closest('#add-group')) {
          input.classList.remove('hidden');
        } else {
          input.classList.add('hidden');
        }
      });
  });
  // addLinkをクリックしたら、入力欄を表示
  // addLink以外をクリックしたら、入力欄を非表示
  document.addEventListener('click', (e) => {
    addLinkInput.forEach(input => {
        if(e.target.closest('#add-link')) {
          input.classList.remove('hidden');
        } else {
          input.classList.add('hidden');
        }
      });
  });

  // ■edit-icon, mask-modal
  const editGroupIcons = document.querySelectorAll('.group .edit-icon');
  const editLinkIcons = document.querySelectorAll('.link .edit-icon');
  const editLinkModal = document.getElementById('edit-link-modal');
  const editGroupModal = document.getElementById('edit-group-modal');
  const maskModal = document.getElementById('mask-modal');

  // groupのedit-iconをクリック
  editGroupIcons.forEach(icon => {
    icon.addEventListener('click', () => {
        // editGroupModal/ maskModalの表示
        editGroupModal.classList.remove('hidden');
        maskModal.classList.remove('hidden');

        // クリックされたedit-iconのdata-id, data-nameを取得
        const id = icon.dataset.id;
        const name = icon.dataset.name;

        // editGroupModalのURLに代入する (Update用)
        editGroupModal.setAttribute('action', `link_groups/${id}`);

        // delete-iconのURLに代入する (Delete用)
        const deleteIcon = document.querySelector('#edit-group-modal .delete-icon');
        deleteIcon.setAttribute('href', `link_groups/${id}`);

        // editGroupModalのnameに代入する
        const groupName =  document.querySelector('#edit-group-modal #link_group_name');
        groupName.setAttribute('value', name);
      });
    });

    // linkのedit-iconをクリック
    editLinkIcons.forEach(icon => {
      icon.addEventListener('click', () => {
          // editLinkModal/ maskModalの表示
          editLinkModal.classList.remove('hidden');
          maskModal.classList.remove('hidden');

          // クリックされたedit-iconのdata-id, data-titleを取得
          const id = icon.dataset.id;
          const title = icon.dataset.title;
          const url = icon.dataset.url;

          // editLinkModalのURLに代入する (Update用)
          editLinkModal.setAttribute('action', `links/${id}`);

          // delete-iconのURLに代入する (Delete用)
          const deleteIcon = document.querySelector('#edit-link-modal .delete-icon');
          deleteIcon.setAttribute('href', `links/${id}`);

          // editLinkModalのtitleに代入する
          const linkTitle =  document.querySelector('#edit-link-modal #link_title');
          linkTitle.setAttribute('value', title);

          // editLinkModalのurlに代入する
          const linkUrl =  document.querySelector('#edit-link-modal #link_url');
          linkUrl.setAttribute('value', url);
        });
      });

    // mask-modalをクリック => editGroupModalまたはeditLinkModalの非表示
    maskModal.addEventListener('click', () => {
      editGroupModal.classList.add('hidden');
      editLinkModal.classList.add('hidden');
      maskModal.classList.add('hidden');
    });

  // ■Home
  const home = document.querySelectorAll('.home');

  // homeをクリック => addLinkフォームの非表示、addGroupフォームの表示
  home.forEach(link => {
    link.addEventListener('click', () => {
      addLink.classList.add('hidden');
      addGroup.classList.remove('hidden');
    });
  });

  // ■Groups (Desktopのみ)
  const desktopGroupLists = document.querySelectorAll('.menu.desktop .group');

  // Groupをmouse-hover/ mouse-out => edit-iconの表示/ 非表示
  // Groupをクリック => addLinkフォームの表示、addGroupフォームの非表示
  desktopGroupLists.forEach(list => {
    list.addEventListener('mouseover', () => {
      const icon = list.lastElementChild;
      icon.classList.remove('hidden');
    });

    list.addEventListener('mouseout', () => {
      const icon = list.lastElementChild;
      icon.classList.add('hidden');
    });

    list.addEventListener('click', () => {
      addLink.classList.remove('hidden');
      addGroup.classList.add('hidden');
    });
  });
}
