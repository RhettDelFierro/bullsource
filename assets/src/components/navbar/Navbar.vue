<template>
  <div>
    <ul class="navbar">
      <li>Home</li>
      <li>Login</li>
      <li>Register</li>
    </ul>
    <button @click="register(userRegister)">Register</button>
  </div>
</template>
<script>
  import { mapGetters, mapActions } from 'vuex'
  import * as types from '../../store/types'

  export default {
    data () {
      return {
        userRegister: {
          username: 'b4lahahahahaha',
          email: 'b4lahahahahahaha@blahahah.com',
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
<style scoped>
  .navbar {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
  }

  @media screen and (max-width: 740px) {
    .navbar {
      top: 90vh;
      background-color: blue;
      grid-template-columns: 50px 1fr 50px;
    }

    li {
      background-color: green;
    }
  }
</style>
