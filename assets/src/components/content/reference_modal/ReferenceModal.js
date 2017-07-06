import React, {Component} from "react";
import styles from "./style.css";
import {graphql} from "react-apollo";
import checkDOIQuery from "../../../queries/checkDOI";
import {organizeReferenceData} from "../../../helpers/data";

class ReferenceModal extends Component {
    constructor(props) {
        super(props);
        this.state = {
            doi: '',
            url: '',
            title: '',
            source: '',
            date: '',
            authors: ''
        };
        this.renderLoading = this.renderLoading.bind(this);
        this.renderReference = this.renderReference.bind(this);
        this.onConfirm = this.onConfirm.bind(this);
    }

    componentWillUpdate(nextProps) {
        if (!this.props.data.doi && nextProps.data.doi) {
            const {doi} = nextProps.data;
            this.setState(organizeReferenceData(doi))
        }
    }

    onConfirm(e) {
        e.preventDefault();
        let state = this.state;
        this.props.onLoadEntity(state)
    }

    renderLoading() {
        return <div>Loading</div>
    }

    renderReference() {
        return (
            <div className={styles['reference-modal-background']}>
                <div className={styles['work-info']}>
                    <a href={this.state.url}>{this.state.title}</a>
                    <p>{this.state.source}</p>
                    <p>{this.state.date}</p>
                    <p>{this.state.authors}</p>
                    <button onClick={this.onConfirm}>Confirm</button>
                </div>
            </div>
        )
    }

    render() {
        console.log(this.props);
        return (
            this.props.data.loading ? this.renderLoading() : this.renderReference()
        )
    }
}

export default graphql(checkDOIQuery, {
        options: ({doi}) => ({variables: {doi}})
    }
)(ReferenceModal);