import React, {Component} from "react";
import styles from "./style.css";
import {withRouter} from 'react-router-dom'

class DropDown extends Component {
    constructor(props){
        super(props);
        this.state = {
            opened: false
        }
    }

    toggleDropdown(){
        this.setState({opened: !this.state.opened})
    }

    render() {
        return (
            <div className={styles['dropdown-container']} onClick={this.toggleDropdown}>
                <div className={styles.dropdown}/>
            </div>

        )
    }
}

export default withRouter(DropDown);