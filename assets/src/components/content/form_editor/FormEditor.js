import React, {Component} from "react";
import {Editor, EditorState, RichUtils, AtomicBlockUtils} from "draft-js";

import DOIBlock from "../doi_block/DOIBlock";
import styles from "./style.css";

import {getBlockRendererFn, resetBlockType} from "../../../helpers/forms";

// const DOI_BLOCK = 'doi_block';

class FormEditor extends Component {
    constructor(props) {
        super(props);
        this.state = {
            editorState: EditorState.createEmpty(),
            showDOIInput: false,
            doiValue: '',
            componentType: '',
            proofs: [],
            doiError: ''
        };
        this.onChange = (editorState) => this.setState({editorState});
        this.handleKeyCommand = this.handleKeyCommand.bind(this);
        this.focus = () => this.refs.editor.focus();
        this.getEditorState = () => this.state.editorState;
        this.onDOIChange = (e) => this.setState({doiValue: e.target.value});
        this.onDOIError = (doiError) => this.setState({doiError});
        this.setProof = (proof) => this.setState({proofs: [proof, ...this.state.proofs]});
        this.confirmDOI = this.confirmDOI.bind(this);
        this.onInsertProof = this.onInsertProof.bind(this);
        this.proxyForBlock = this.proxyForBlock.bind(this);
        this.blockRendererFn = getBlockRendererFn(this.getEditorState, this.onChange, this.setProof, this.onDOIError, DOIBlock);
    }

    handleKeyCommand(command) {
        const newState = RichUtils.handleKeyCommand(this.state.editorState, command);
        if (newState) {
            this.onChange(newState);
            return 'handled';
        }
        return 'not-handled';
    }

    onBoldClick() {
        this.onChange(RichUtils.toggleInlineStyle(this.state.editorState, 'BOLD'));
        setTimeout(() => this.focus(), 0);
    }

    onUnderlineClick() {
        this.onChange(RichUtils.toggleInlineStyle(this.state.editorState, 'UNDERLINE'));
        // setTimeout(() => this.focus(), 0);
    }

    onItalicClick() {
        this.onChange(RichUtils.toggleInlineStyle(this.state.editorState, 'ITALIC'));
        setTimeout(() => this.focus(), 0);
    }

    confirmDOI(e) {
        e.preventDefault();
        const {editorState, doiValue, componentType} = this.state;
        const contentState = editorState.getCurrentContent(); //get the current editor's content (all of it)
        const contentStateWithEntity = contentState.createEntity( //inserting an entity for the proof code block.
            componentType,
            'IMMUTABLE',
            {doiValue}
        );
        const entityKey = contentStateWithEntity.getLastCreatedEntityKey();
        const newEditorState = EditorState.set(
            editorState,
            {currentContent: contentStateWithEntity}
        );
        //we now have a new editorState with the entity we created:
        this.setState({
            editorState: AtomicBlockUtils.insertAtomicBlock(
                newEditorState,
                entityKey,
                ' ' //means the whole work block will be represented by a space that you can delete by hitting delete/backspace key.
            ),
            showDOIInput: false, //reset the doi form with these two lines.
            doiValue: '',
        }, () => {
            setTimeout(() => this.focus(), 0); //focus back on editor.
        });
    }

    //if user presses enter during doi confirmation:
    onDOIInputKeyDown(e){
        if (e.which === 13) {
            this.confirmDOI(e);
        }
    }

    //Will show the doi input form and tell draft-js to render the work info component:
    proxyForBlock(type) {
        this.setState({
            showDOIInput: true,
            doiValue: '',
            componentType: type
        }, () => {
            setTimeout(() => this.refs.doi.focus(), 0);
        })
    }

    onInsertProof(){
        this.proxyForBlock('proof')
    }

    render() {

        let doiInput;
        if (this.state.showDOIInput) {
            //the doi "form" that gets toggled if this.state.showDOIInput is true:
            doiInput =
                <div className={styles['doi-input-container']}>
                    <input
                        onChange={this.onDOIChange}
                        ref="doi"
                        className={styles['doi-input']}
                        type="text"
                        value={this.state.doiValue}
                        onKeyDown={this.onDOIInputKeyDown}
                    />
                    <button onClick={this.confirmDOI}>
                        Confirm
                    </button>
                </div>;
        }
        return (
            <div className={styles['form-container']}>
                <button onClick={this.onBoldClick.bind(this)}>Bold</button>
                <button onClick={this.onUnderlineClick.bind(this)}>Underline</button>
                <button onClick={this.onItalicClick.bind(this)}>Italic</button>
                <button onClick={this.onInsertProof}>Insert Proof</button>
                {doiInput}
                {!this.state.doiError ? '' : `${this.state.doiError}`}
                <div className={styles.editor} onClick={this.focus}>
                    <Editor editorState={this.state.editorState}
                            onChange={this.onChange}
                            handleKeyCommand={this.handleKeyCommand}
                            ref="editor"
                            blockRendererFn={this.blockRendererFn}
                    />
                <button>Submit</button>
                </div>
            </div>

        );
    }
}

export default FormEditor