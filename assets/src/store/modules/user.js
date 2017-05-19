import * as types from '../types'
import axios from 'axios'

const state = {
  user: {}
}

const getters = {
  [types.GET_USER]: state => {
    return state.user
  },
  // types.LOGGED_IN_BOOL :: bool
  [types.LOGGED_IN_BOOL]: state => {
    return !!state.user
  }
}

const mutations = {
  [types.SET_USER]: (state, payload) => {
    state.user = payload
  }
}

const actions = {
  // payload :: { username, email, password }
  [types.USER_REGISTER]: (context, payload) => {
    return new Promise((resolve, reject) => {
      axios.post('http://localhost:4000/api/users', { user: payload }).then(response => {
        if (response.status === 200) {
          console.log(response)
          context.commit('SET_USER', response.data.user)
          context.commit('SET_JWT', response.data.jwt)
          resolve()
        } else {
          console.log(response.errors)
          context.commit('SET_REGISTRATION_ERRORS', response.errors)
          reject()
        }
      })
    })
  },
  [types.USER_LOGIN]: ({commit}, payload) => {
  }
}

export default {
  state,
  mutations,
  actions,
  getters
}