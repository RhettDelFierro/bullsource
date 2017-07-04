import React, {Component} from "react";
import {EditorBlock} from 'draft-js';
import {graphql} from "react-apollo";
import checkDOIQuery from "../../../queries/checkDOI";
import {resetBlockType, updateDataOfBlock} from "../../../helpers/forms";
import {organizeReferenceData} from "../../../helpers/data";
import styles from "./style.css";

class ReferenceBlock extends Component {
    componentWillUpdate(nextProps) {
        const {block, blockProps} = this.props;
        const {onChange, getEditorState} = blockProps;
        const fetched = block.getData().get('fetched');

        if (!this.props.data.doi && nextProps.data.doi && !fetched) {
            const {doi} = nextProps.data;
            let newData = organizeReferenceData(doi);
            onChange(updateDataOfBlock(getEditorState(), block, newData(block)));
        }
        else if (!this.props.data.error && nextProps.data.error) {
            console.log('error', nextProps.data.error);
            //don't want to set data of an error. Maybe you just want to delete this block. Or go back to rendering the reference block but with an error message?
        }
        if (fetched) {
            const editorState = getEditorState();
            const selection = editorState.getSelection();
            const afterBlock = editorState.getCurrentContent().getBlockAfter(selection.getAnchorKey());
            // console.log('block type:', currentBlock.getType());
            onChange(resetBlockType(editorState, 'unstyled'))
        }
    }

    renderWork() {
        const {block} = this.props;
        const data = block.getData();
        const authors = this.props.data.error ? '' : data.get('authors');
        return this.props.data.error ? <div>Error</div> :
                <div className={styles['work-info']}>
                    <a href={data.get('url')}>{data.get('title')}</a>
                    <p>{data.get('source')}</p>
                    <p>{data.get('date')}</p>
                    <p>{authors}</p>
                </div>
    }

    render() {
        const {loading} = this.props.data;
        return (
            loading ?
                <div>Loading</div>
                :
                this.renderWork()

        )
    }


}

export default graphql(checkDOIQuery, {
    options: (props) => {
        const {block} = props;
        const data = block.getData();
        const doi = data.get('doi');
        return {variables: {doi}}
    }
})(ReferenceBlock);