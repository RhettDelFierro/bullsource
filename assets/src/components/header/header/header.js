import React, {Component} from "react";
import CategoryNav from "../category_nav/CategoryNav";
import Hamburger from "../hamburger/Hamburger";
import screenSize from "../../hoc/screenSize";
import style from "./style.css"

class Header extends Component {
    render() {
        return (
            <div className={style.header}>
                <CategoryNav isMobile={this.props.isMobile}/>
                {this.props.isMobile ? <Hamburger /> : ''}
            </div>

        )

    }
}

export default screenSize(Header);