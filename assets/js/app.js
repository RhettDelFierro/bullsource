import Vue from 'vue'
import VueRouter from 'vue-router';
import Main from './Main.vue'

import { routes } from './routes';
Vue.use(VueRouter);

const router = new VueRouter({
    routes
});

console.log(mMain);

new Vue({
    el: '#main_container',
    router,
    render: h => h(Main)
});
