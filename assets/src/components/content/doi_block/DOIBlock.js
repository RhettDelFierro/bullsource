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
        this.text1Focus = () => this.refs.text1.focus();
        this.text2Focus = () => this.refs.text2.focus();
        this.focus = () => this.refs.proof.focus();
    }

    componentWillReceiveProps(nextProps) {
        const {error,doi} = nextProps.data;
        const {blockProps} = this.props;
        const {onDOIError} = blockProps;
        if (error) {
            let errorMessage = error.message.split(':')[2];
            console.log(errorMessage);
            onDOIError(errorMessage)
        } else if (doi) {
            const {url, title, indexed, containerTitle, author} = doi[0];
            this.setState({
                link: url,
                title: title[0],
                source: containerTitle[0],
                date: `${indexed.dateParts[1]}/${indexed.dateParts[2]}/${indexed.dateParts[0]}`,
                authors: author.map(name => `${name.given} ${name.family}`)
            })
        }
    }

    onSubmit(e) {
        e.preventDefault();
        const {blockProps} = this.props;
        const {setProof} = blockProps;
        setProof(this.state);
        //should also tell the FormEditor component to re render the content block.
    }

    renderForm() {
        return this.props.data.isLoading ? <div>Loading</div> :
            <div className={styles['work-info']} onClick={this.focus} ref="proof">
                <form>
                    <textarea ref="text1" onClick={this.text1Focus} placeholder="Text from source goes here"
                              onChange={(event) => this.setState({article: event.target.value})}>
                    </textarea>
                    <textarea ref="text2" onClick={this.text2Focus} placeholder="Your thoughts go here"
                              onChange={(event) => this.setState({coments: event.target.value})}>
                    </textarea>
                    <a href={this.state.link}>{this.state.title}</a>
                    <p>{this.state.source}</p>
                    <p>{this.state.date}</p>
                    <p>{this.state.authors.map(author => author + ', ')}</p>
                    <button onClick={this.onSubmit.bind(this)}>Proof</button>
                </form>
            </div>

    }

    render() {
        return this.renderForm()
    }


}

export default graphql(checkDoiQuery, {
    options: (props) => {
        const entity = props.contentState.getEntity(
            props.block.getEntityAt(0)
        );
        const {doiValue} = entity.getData();
        return {variables: {doi: doiValue}}
    }
})(DOIBlock);