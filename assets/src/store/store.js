import Vue from 'vue';
import Vuex from 'vuex';

//for more general
import actions from './actions';
import getters from './getters';
import mutations from './mutations';

import user from './modules/user'

Vue.use(Vuex);

export const store = new Vuex.Store({
  state: {
  },
  getters,
  mutations,
  actions,
  modules: {
    user
  }
});
