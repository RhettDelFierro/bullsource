import React, {Component} from 'react'
import screenSize from '../../hoc/screenSize'
import style from "./style.css"
import UserPanel from "../user_panel/user_panel"

class SidePanel extends Component {
    render(){
        return(
            <div className={style['side-panel']}>
                <UserPanel {...this.props}/>
            </div>
            )

    }
}

export default screenSize(SidePanel);