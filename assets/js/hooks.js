let Hooks = {} // containing object for any JS hooks...

Hooks.AutoFocus = {
  mounted() {
    this.el.focus()
  }
}

Hooks.ScrollToEnd = {
  mounted() {
    this.chatroom = document.querySelector('#chatroom')
    this.board = document.querySelector('#board')
    this.resizeHack = (_e) => {
      const width = this.board.getBoundingClientRect().width
      // Ensure board remains square...
      this.board.style.height = width + 'px'
      // Ensure chatroom remains aligned with board...
      this.chatroom.style.maxHeight = width + 'px'
      // Memorize height of chatroom...
      this.height = width
    }
    window.addEventListener('resize', this.resizeHack)
    this.resizeHack()
  },
  updated() {
    // Ensure chatroom remains aligned with board...
    this.chatroom.style.maxHeight = this.height + 'px'
    // Scroll to end of message list...
    this.el.scrollTop = this.el.scrollHeight
  }
}

Hooks.MobileMenu = {
  mounted() {
    const hamburgerBtn = document.querySelector('#hamburger-button')
    const mobileMenu = document.querySelector('#mobile-menu')

    const toggleMenu = () => {
      mobileMenu.classList.toggle('hidden')
      mobileMenu.classList.toggle('flex')
      // Turns clockwise adding the class and counterclockwise removing it.
      hamburgerBtn.classList.toggle('toggle-btn')
    }

    hamburgerBtn.addEventListener('click', toggleMenu)
    mobileMenu.addEventListener('click', toggleMenu)
  }
}

export default Hooks
