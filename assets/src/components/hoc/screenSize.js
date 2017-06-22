import React, {Component} from "react";

export default (WrappedComponent) => {
    class ScreenSize extends Component {
        constructor(props) {
            super(props);
            this.checkScreenWidth = this.checkScreenWidth.bind(this);
            this.state = {isMobile: false}
        }

        checkScreenWidth() {
            if (window.innerWidth <= 440) {
                this.setState({isMobile: true})
            } else {
                this.setState({isMobile: false})
            }
        }

        componentWillMount() {
            this.checkScreenWidth();
        }

        componentDidMount() {
            window.addEventListener('resize', this.checkScreenWidth);
        }

        componentWillUnmount() {
            window.removeEventListener("resize", this.checkScreenWidth);
        }

        render() {
            return <WrappedComponent isMobile={this.state.isMobile} {...this.props} />
        }
    }
    return ScreenSize;
}

