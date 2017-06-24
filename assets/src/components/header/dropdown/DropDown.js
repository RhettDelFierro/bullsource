import React, {Component} from "react";
import styles from "./style.css";
import {withRouter, NavLink} from "react-router-dom";

class DropDown extends Component {
    constructor(props) {
        super(props);
        this.state = {
            opened: false
        }
    }

    toggleDropdown() {
        this.setState({opened: !this.state.opened})
    }

    render() {
        const dropDownClass = `${styles.overlay} ${styles["dropdown-content"]}`;
        return (
            <div className={styles['dropdown-container']} onClick={this.toggleDropdown}>
                <div className={styles.dropdown} onClick={this.toggleDropdown.bind(this)}><i>Bullsource</i><i
                    className="fa fa-caret-down" aria-hidden="true"/></div>
                {this.state.opened ?
                    <div className={dropDownClass}>
                        <NavLink exact activeClassName={styles.active} to='/'>Home</NavLink>
                        <NavLink activeClassName={styles.active} to='/category/entertainment'>Entertainment</NavLink>
                        <NavLink activeClassName={styles.active} to='/category/gaming'>Gaming</NavLink>
                        <NavLink activeClassName={styles.active} to='/category/general'>General</NavLink>
                        <NavLink activeClassName={styles.active} to='/category/music'>Music</NavLink>
                        <NavLink activeClassName={styles.active} to='/category/politics'>Politics</NavLink>
                        <NavLink activeClassName={styles.active} to='/category/science-and-nature'>Science and
                            Nature</NavLink>
                        <NavLink activeClassName={styles.active} to='/category/sport'>Sport</NavLink>
                        <NavLink activeClassName={styles.active} to='/category/technology'>Technology</NavLink>
                    </div>
                    : ''
                }

            </div>

        )
    }
}

export default withRouter(DropDown);