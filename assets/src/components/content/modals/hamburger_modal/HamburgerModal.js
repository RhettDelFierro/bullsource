import React, {Component} from "react";
import {graphql} from "react-apollo";

import currentUserQuery from "../../../../queries/currentUser";
import styles from "./style.css";


class HamburgerModal extends Component {
    constructor(props) {
        super(props);

    }

    renderStatus() {
        const {currentUser} = this.props.data;
        if (currentUser) {
            return (
                <div className={styles['user-info']}>
                    <div><div><i className="fa fa-user" aria-hidden="true" /></div> <div>{currentUser.username}</div></div>
                    <div><div><i className="fa fa-envelope-open" aria-hidden="true"/></div><div>messages</div></div>
                    <div><p>About Bullsource</p></div>
                </div>
            )
        } else {
            return (
                <div className={styles.visitor}>
                    Sign up!
                </div>
            )
        }
    }

    render() {

        return (
            <div className={styles.overlay}>
                {this.renderStatus()}
            </div>
        )
    }
}

export default graphql(currentUserQuery)(HamburgerModal)