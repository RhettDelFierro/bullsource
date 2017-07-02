import React from "react";
import {graphql} from "react-apollo";
import styles from "./style.css";

import checkDoiQuery from "../../../queries/checkDOI";


class DOIBlock extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            url: '',
            title: '',
            source: '',
            date: '',
            authors: []
        };
    }

    componentWillReceiveProps(nextProps) {
        // const {error, doi} = nextProps.data;
        const {onCheckInvalidDOI} = this.props.editor.props;
        if (nextProps.data.error) {
            const {error} = nextProps.data;
            let errorMessage = error.message.split(':')[2];
            onCheckInvalidDOI(errorMessage);
        } else if (nextProps.data.doi) {
            const {doi} = nextProps.data;
            const {url, title, indexed, containerTitle, author} = doi[0];
            const authors = author.map(name => `${name.given} ${name.family}`);
            const {node, editor} = this.props;
            // console.log(editor);
            const data = {
                url,
                title: title[0],
                source: containerTitle[0],
                date: `${indexed.dateParts[0][1]}/${indexed.dateParts[0][2]}/${indexed.dateParts[0][0]}`,
                authors: authors
            };

            const properties = {data};
            // editor.props.setProofs({data});

            const next = editor
                .getState()
                .transform()
                .setNodeByKey(node.key, properties)
                .apply();

            editor.onChange(next)
        }
    }

    renderWork() {
        const data = this.props.node.data;
        const authors = this.props.data.error ? '' : data.get('authors').map(author => author + ', ');
        return this.props.data.error ? <div/> :
            <div className={styles['work-info']}>
                <a href={data.get('url')}>{data.get('title')}</a>
                <p>{data.get('source')}</p>
                <p>{data.get('date')}</p>
                <p>{authors}</p>
            </div>
    }

    render() {
        return (
            <div {...this.props.attributes}>
                {this.props.data.loading ?
                    <div>Checking for DOI</div>
                    : this.renderWork()}
            </div>
        )
    }

}

export default graphql(checkDoiQuery, {
    options: (props) => {
        const doi = props.editor.props.doi[0];
        return {variables: {doi}}
    }
})(DOIBlock);