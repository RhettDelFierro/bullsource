import React, {Component} from "react";
import screenSize from "../../hoc/screenSize";
import UserPanel from "../user_panel/user_panel";

import style from "./style.css";

//props: authed and isMobile, will also have data.currrentUser
class SidePanel extends Component {
    render() {
        return this.props.isMobile ?
            <div />
            :
            <div className={style['side-panel']}>
                <UserPanel {...this.props}/>
            </div>
    }
}

export default screenSize(SidePanel);