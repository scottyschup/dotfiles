import { createSelector } from '@reduxjs/toolkit';

import { T<FTName>State } from '.';
import { TAppState } from '../../../rootStore';

export const select<FTName>State = (state: TAppState): T<FTName>State => state.<FTName | lowercasefirstchar>;
export const select<FTName>Data = createSelector(
  select<FTName>State,
  (<FTName | lowercasefirstchar>State: T<FTName>State): any => <FTName | lowercasefirstchar>State?.<FTName | lowercasefirstchar>
);
