import React, {Component} from "react";
import screenSize from "../../hoc/screenSize";

class Header extends Component {
    render() {
        return (
            <div>
                Header
            </div>
        )

    }
}

export default screenSize(Header);