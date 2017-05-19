<template>
  <div class="registerPage">
    <input placeholder="username" type="text">
    <input placeholder="email" type="text">
    <input placeholder="password" type="password">
    <button @click="register(userRegister)">Register</button>
  </div>
</template>
<script>
  import { mapGetters, mapActions } from 'vuex'
  import * as types from '../../store/types'

  export default{
    data () {
      return {
        userRegister: {
          username: 'b5lahahahahaha',
          email: 'b5lahahahahahaha@blahahah.com',
          password: 'someblahhahapassword'
        }
      }
    },
    computed: {
      ...mapGetters({
        loggedIn: types.LOGGED_IN_BOOL
      })
    },
    methods: {
      ...mapActions({
        register: types.USER_REGISTER
      })
    }
  }
</script>
<style>
  .registerPage {
    display: grid;
    height: 15vh;
    width:40vw;
    grid-template-rows: repeat(4, 1fr);
  }
</style>
