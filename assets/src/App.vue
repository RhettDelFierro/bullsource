<template>
  <div id="app">
    <nav-bar></nav-bar>
    <transition name="slide">
      <router-view></router-view>
    </transition>

  </div>
</template>

<script>
  import Navbar from './components/navbar/Navbar.vue'

  export default {
    name: 'app',
    components: {
      'nav-bar': Navbar
    }
  }
</script>

<style>
  #app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
  }

  li {
    list-style: none;
  }

  .slide-enter-active {
    animation: component-in 1s forwards;
  }

  @keyframes component-in {
    0% {
      opacity: 0;
      transform: translateX(-30px);
    }
    100% {
      opacity: 1;
      transform: translateX(0);
    }
  }
</style>
