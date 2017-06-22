import React, {Component} from 'react'
import screenSize from '../../hoc/screenSize'

class SidePanel extends Component {
    render(){
        return(
            <div>
                Side Panel
            </div>
            )

    }
}

export default screenSize(SidePanel);