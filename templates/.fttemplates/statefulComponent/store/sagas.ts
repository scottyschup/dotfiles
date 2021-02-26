import { SagaIterator } from 'redux-saga';
import { all, call, take, spawn } from 'redux-saga/effects';
import { bindAsyncAction } from 'typescript-fsa-redux-saga';

import { fetch<FTName>, fetch<FTName>Action } from '.';

function* callFetch<FTName> (): SagaIterator {
  return yield call(fetch<FTName>);
}

const fetch<FTName>Worker = bindAsyncAction(fetch<FTName>Action)(callFetch<FTName>);

export function* fetch<FTName>Saga (): SagaIterator {
  while (true) {
    const { payload } = yield take(fetch<FTName>Action.someActionType);
    yield call(fetch<FTName>Worker, payload);
  }
}
// Export all
export default function* <FTName | lowercasefirstchar>Sagas (): SagaIterator {
  yield all([
    spawn(fetch<FTName>Saga),
  ]);
}
