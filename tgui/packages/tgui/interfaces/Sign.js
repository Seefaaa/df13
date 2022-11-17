import { Loader } from './common/Loader';
import { InputButtons } from './common/InputButtons';
import { Box, Button, TextArea, Section, Stack } from '../components';
import { KEY_A, KEY_DOWN, KEY_ESCAPE, KEY_ENTER, KEY_UP, KEY_Z } from '../../common/keycodes';
import { Window } from '../layouts';
import { useBackend, useLocalState } from '../backend';

const DecalList1 = (props, context) => {
  const { act, data } = useBackend(context);
  const { decals, current_decal, selected_decal_1 } = data;
  const { selectable_decals, decal_num } = props;

  return (
    <Section fill scrollable>
      {selectable_decals.map(entry => (
        <Button
          key={entry}
          title={entry}
          content={entry}
          selected={entry === selected_decal_1}
          onClick={() => act('set_decal_1', {
            selected_decal_1: entry,
          })}
        />
      ))}
    </Section>
  );
};

const DecalList2 = (props, context) => {
  const { act, data } = useBackend(context);
  const { decals, current_decal, selected_decal_2 } = data;
  const { selectable_decals, decal_num } = props;

  return (
    <Section fill scrollable>
      {selectable_decals.map(entry => (
        <Button
          key={entry}
          title={entry}
          content={entry}
          selected={entry === selected_decal_2}
          onClick={() => act('set_decal_2', {
            selected_decal_2: entry,
          })}
        />
      ))}
    </Section>
  );
};


export const Sign = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    decals,
    current_decal,
    text,
    selected_decal,
    selected_decal_1,
  } = data;
  const [input_text, setText] = useLocalState(
    context, 'text', '');
  return (
    <Window
      width={650}
      height={415}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <TextArea
              height="200px"
              mb={1}
              fluid
              autoFocus
              placeholder="Text"
              value={input_text}
              onInput={(e, value) => setText(value)} />
          </Stack.Item>
          <Stack.Item mt={0} grow={1} basis={0}>
            <DecalList1
              selectable_decals={decals}
            />
          </Stack.Item>
          <Stack.Item mt={0} grow={1} basis={0}>
            <DecalList2
              selectable_decals={decals}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="pick color"
              title="Pick color"
              onClick={() => act('pick_color', {
              })}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              content="Write!"
              title="Write!"
              onClick={() => act('write', {
                text: text,
              })}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );


};
