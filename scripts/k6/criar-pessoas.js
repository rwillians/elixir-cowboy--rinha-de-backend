import { check } from 'k6';
import { SharedArray } from 'k6/data';
import exec from 'k6/execution';
import http from 'k6/http';

export const options = {
  thresholds: {
    http_req_failed: ['rate<0.01'],    // http errors should be less than 1%
    http_req_duration: ['p(95)<200'], // 95% of requests should be below 200ms
  },
  scenarios: {
    // find_breaking_point: {
    //   executor: 'ramping-arrival-rate',
    //   stages: [
    //     { duration: '5s', target: 50 },
    //     { duration: '5s', target: 200 },
    //     { duration: '10s', target: 500 },  // - Ramping up the number of req/s up
    //     { duration: '30s', target: 1000 }, //   to 1000 req/s over a couse of 50 seconds;
    //     { duration: '30s', target: 1000 }, // - Try to sustain 1000 req/s;
    //     { duration: '30s', target: 2000 }, // - Try ramping up to 2000 req/s.
    //     { duration: '30s', target: 2000 }, // - Then try to sustain 2000 req/s;
    //     { duration: '30s', target: 2500 }, // - Can we push it to 2500 req/s?;
    //     { duration: '30s', target: 3000 }, // - And what about 3000 req/s?;
    //     { duration: '30s', target: 4000 }, // - 4000 req/s?;
    //     { duration: '30s', target: 5000 }, // - 5000 req/s?;
    //   ],
    //   preAllocatedVUs: 500,
    //   maxVUs: 2000,
    //   startRate: 1,
    //   timeUnit: '1s'
    // },
    ramping_up: {
      executor: 'ramping-vus',
      stages: [
        { duration: '5s', target: 50 },
        { duration: '5s', target: 200 },
        { duration: '5s', target: 500 },
        { duration: '10s', target: 1000 },
        { duration: '30s', target: 2000 },
        { duration: '30s', target: 4000 },
        { duration: '30s', target: 5000 },
        //                         ^ bora ver se chega em 1000 req/s
      ],
      startVUs: 1,
      preAllocatedVUs: 5000,
      gracefulRampDown: '2s'
    },
    // criar_pessoas: {
    //   executor: 'shared-iterations',
    //   iterations: 250000, // 500 virtual users will run as fast as possible to
    //   vus: 500,           // complete 250k insertions.
    //   gracefulStop: '5s',
    //   maxDuration: '5m'
    // }
  },
  discardResponseBodies: true,
};

const users = new SharedArray('pessoas.jsonl', function () {
  return open('pessoas.jsonl').split('\n');
});

export default function () {
  // const user = users[~~(Math.random() * users.length)];
  const user = users[exec.scenario.iterationInTest];

  const res = http.post('http://localhost:8080/pessoas', user, {
    headers: { 'Content-Type': 'application/json' }
  });

  check(res, {
    'status is 201 or 422': (r) => [201, 422].includes(res.status),
  });
}