import * as types from '../types';
import axios from 'axios';
import moment from "moment-timezone";

const state = {
  user: {}
};

const getters = {
  [types.GET_USER]: state => {
    return state.user;
  }
};

const mutations = {
  [types.SET_USER]: (state, payload) => {
    state.user = payload;
  }
};

const actions = {
  [types.REGISTER]: (context, payload) => {
    return new Promise((resolve, reject) => {
      let obj = {
        description: payload,
        date: context.state.eventFormDate
      };

      axios.post('/api/', obj).then(response => {
        if (response.status === 200) {
          context.commit('SET_USER', response.data.user);
          resolve();
        } else {
          reject();
        }
      })

    })
  },
  [types.LOGIN]: ({commit}, payload) => {
  }
};

export default {
  state,
  mutations,
  actions,
  getters
}
