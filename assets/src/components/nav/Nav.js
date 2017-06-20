import React, {Component} from "react";
import {NavLink} from "react-router-dom";
import { graphql } from 'react-apollo'
import "./style.css";

import currentUserQuery from "../../queries/currentUser";
import signOutMutation from "../../mutations/signout";

class Nav extends Component {
    // componentWillReceiveProps(nextProps){
    //     if (this.props.data.currentUser !== nextProps.data.currentUser) {
    //
    //     }
    // }
    onLogout() {
        this.props.mutate({}).then((res) => {
            // res.data.signOut.id and res.data.signOut.username
            localStorage.removeItem('token');
            this.props.data.refetch();
        })
    }

    renderStatus() {
        const {loading, currentUser} = this.props.data;
        if (loading) {
            return <div />
        }
        if (currentUser) {
            return (
                <ul className='nav'>
                    <li>Welcome {currentUser.username}</li>
                    <li>
                        <a onClick={this.onLogout.bind(this)}>
                            Log Out
                        </a>
                    </li>
                </ul>
            )
        } else {
            return (
                <ul className='nav'>
                    <li>
                        <NavLink activeClassName='active' to='/signup'>Sign-Up</NavLink>
                    </li>
                    <li>
                        <NavLink activeClassName='active' to='/signin'> Sign-In</NavLink>
                    </li>
                </ul>
            )
        }
    }

    render() {
        return (
            <div>
                {this.renderStatus()}
            </div>
        )
    }
}

export default graphql(signOutMutation)(graphql(currentUserQuery)(Nav));

