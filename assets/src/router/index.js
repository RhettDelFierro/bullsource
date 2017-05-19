import Vue from 'vue'
import Router from 'vue-router'
import Home from '../components/Home.vue'
import RegisterPage from '../components/forms/RegisterPage.vue'

Vue.use(Router)

export default new Router({
  routes: [
    { path: '/', name: 'Home', component: Home },
    { path: '/register', name: 'RegisterPage', component: RegisterPage }
  ]
})
