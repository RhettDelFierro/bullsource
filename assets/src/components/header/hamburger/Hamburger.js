import React, {Component} from "react";
import styles from "./style.css";

import HamburgerModal from "../../content/modals/hamburger_modal/HamburgerModal"

class Hamburger extends Component {
    constructor(props) {
        super(props);
        this.state = {
            opened: false
        }
    }

       // componentWillReceiveProps(nextProps){
    //     if (this.state.opened !== nextProps.hamburgerOpened){
    //         this.setState({
    //             opened: !this.state.opened
    //         })
    //     }
    // }

    toggleHamburger() {
        this.setState({opened: !this.state.opened})
    }

    render() {
        const hamburgerClasses = this.state.opened ?
            `${styles['hamburger-container']} ${styles['hamburger-container-clicked']}`
            : styles['hamburger-container'];

        return (

            <div className={hamburgerClasses}
                 onClick={this.toggleHamburger.bind(this)}>
                <div className={styles.hamburger}/>
                {this.state.opened ? <HamburgerModal /> : ''}
            </div>

        )
    }
}

export default Hamburger;