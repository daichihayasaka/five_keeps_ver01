'use strict';

{
  // ■ユーザーの削除
  const deleteLink = document.getElementById('delete-link');
  const deleteUserModal = document.getElementById('delete-user-modal');
  const maskModal = document.getElementById('mask-modal');

    // deleteLinkをクリック => deleteUserModalの表示、mask-modalの表示
    deleteLink.addEventListener('click', (e) => {
      e.preventDefault();
      deleteUserModal.classList.remove('hidden');
      maskModal.classList.remove('hidden');
    });
    // mask-modalをクリック => deleteUserModal、mask-modalの非表示
    maskModal.addEventListener('click', () => {
      deleteUserModal.classList.add('hidden');
      maskModal.classList.add('hidden');
    });
}
