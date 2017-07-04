import React, {Component} from "react";
import {convertToRaw, Editor, EditorState, AtomicBlockUtils} from "draft-js";
import styles from "./style.css";
import {REFERENCE_TYPE,getBlockRendererFn} from "../../../helpers/forms";

class FormEditor extends Component {
    constructor(props) {
        super(props);
        this.state = {
            editorState: EditorState.createEmpty(),
            showDOI: false,
            doi: ''
        };
        this.getEditorState = () => this.state.editorState;
        this.onChange = (editorState) => this.setState({editorState});
        this.blockRendererFn = getBlockRendererFn(this.getEditorState, this.onChange, this.focus)
        this.addDOI = this.addDOI.bind(this);
        this.confirmDOI = this.confirmDOI.bind(this);
        this.focus = () => this.refs.editor.focus();
    }

    confirmDOI(e){
        e.preventDefault();

        const {editorState, doi} = this.state;
        const contentState = editorState.getCurrentContent();
        const contentStateWithEntity = contentState.createEntity(
            REFERENCE_TYPE,
            'IMMUTABLE',
            {doi}
        );

        const entityKey = contentStateWithEntity.getLastCreatedEntityKey();
        const newEditorState = EditorState.set(
            editorState,
            {currentContent: contentStateWithEntity}
        );
        this.setState({
            editorState: AtomicBlockUtils.insertAtomicBlock(
                newEditorState,
                entityKey,
                ' '
            ),
            showDOI: false,
            doi: '',
        }, () => {
            setTimeout(() => this.focus(), 0);
        });

    }

    addDOI(){
        this.setState({
            showDOI: true,
            doi: ''
        },() => {
            setTimeout(() => this.refs.doi.focus(), 0);
        });
    }

    render() {
        let doiInput;
        if (this.state.showDOI) {
            doiInput =
                <div>
                    <input
                        onChange={(e) => this.setState({doi: e.target.value})}
                        ref="doi"
                        type="text"
                        value={this.state.doi}
                    />
                    <button onMouseDown={this.confirmDOI}>
                        Confirm
                    </button>
                </div>;
        }
        return (
            <div className={styles['full-container']}>
                <button onClick={this.addDOI}>Add DOI</button>
                {doiInput}
                <div className={styles['form-container']} onClick={this.focus}>
                    <Editor editorState={this.state.editorState}
                            ref="editor"
                            placeholder="Write here..."
                            onChange={this.onChange}
                            blockRendererFn={this.blockRendererFn}
                    />
                </div>
            </div>
        )
    }
}

export default FormEditor;