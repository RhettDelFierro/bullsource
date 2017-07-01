import React from "react";
import {graphql} from "react-apollo";
import styles from "./style.css";

import checkDoiQuery from "../../../queries/checkDOI";


class DOIBlock extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            article: '',
            comments: '',
            link: '',
            title: '',
            source: '',
            date: '',
            authors: []
        };
        this.focus = () => this.refs.proof.focus();
    }

    componentWillReceiveProps(nextProps) {
        const {error,doi} = nextProps.data;
        const {onCheckInvalidDOI} = this.props.editor.props;
        if (error) {
            let errorMessage = error.message.split(':')[2];
            onCheckInvalidDOI(errorMessage);
        } else if (doi) {
            const {url, title, indexed, containerTitle, author} = doi[0];
            this.setState({
                link: url,
                title: title[0],
                source: containerTitle[0],
                date: `${indexed.dateParts[0][1]}/${indexed.dateParts[0][2]}/${indexed.dateParts[0][0]}`,
                authors: author.map(name => `${name.given} ${name.family}`)
            })
        }
    }

    onSubmit(e) {
        e.preventDefault();
        //might have to set new content blocks here.

        const {block, blockProps} = this.props;
        setProof(this.state);
    }

    renderForm() {
        if(this.props.data.loading){
            return <div>Checking for DOI</div>
        }
        else {
            return this.props.data.error ? <div/> :
               <div className={styles['work-info']} onClick={this.focus} ref="proof">
                    <form>
                        <a href={this.state.link}>{this.state.title}</a>
                        <p>{this.state.source}</p>
                        <p>{this.state.date}</p>
                        <p>{this.state.authors.map(author => author + ', ')}</p>
                        <button onClick={this.onSubmit.bind(this)}>Proof</button>
                    </form>
               </div>
        }

    }

    render() {
        return this.renderForm()
    }

}

export default graphql(checkDoiQuery, {
    options: (props) => {
        const doi = props.editor.props.doi[0];
        return {variables: {doi}}
    }
})(DOIBlock);