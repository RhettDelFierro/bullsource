<template>
  <div>
    <ul class="navbar">
      <li>Home</li>
      <li>Login</li>
      <router-link to="/register" tag="li" active-class="active"><a>Register</a></router-link>
    </ul>
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
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: 1fr;
    padding: 0;
    grid-gap: 0;
  }

  .active {
    background-color: green;
  }

  @media screen and (max-width: 740px) {
    .navbar {
      background-color: blue;

    }

  }
</style>
