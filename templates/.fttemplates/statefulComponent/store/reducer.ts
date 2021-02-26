import produce from 'immer';
import { reducerWithInitialState } from 'typescript-fsa-reducers';

import { T<FTName>State } from '.';

export const initial<FTName>State: T<FTName>State = {};

export const <FTName | lowercasefirstchar>Reducer = reducerWithInitialState(initial<FTName>State)
  .default((state: T<FTName>State) => produce(state, () => state))
;
