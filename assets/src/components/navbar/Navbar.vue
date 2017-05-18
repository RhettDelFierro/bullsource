<template>
  <div>
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
<style>

</style>
