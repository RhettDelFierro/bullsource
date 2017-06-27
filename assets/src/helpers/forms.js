import {Map} from 'immutable';

const DOI_BLOCK = 'doi_block';


/* The block renderer function applied to each block in draft-js editor component
*
* Parameters
*   getEditorState :: EditorState                  -/>  snapshot of the state of the editor.
*   onChange       :: EditorState -> Object -> ()  -/>  create and set new EditorState objects
*
* Returns
*   ContentBlock -> Object
* */
export const getBlockRendererFn = (getEditorState, onChange)
    => (block) => {
    const type = block.getType();
    switch(type) {
        case DOI_BLOCK:
            return {
                component: TodoBlock,
                props: {
                    getEditorState,
                    onChange,
                }
            };
        default:
            return null;
    }
};
