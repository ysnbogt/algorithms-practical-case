import { prompt } from 'enquirer';
import colors, { Color } from 'colors';
import execa from 'execa';

type Difficulty = 'Easy' | 'Medium' | 'Hard';
type ReturnType = 'void' | 'string' | 'number' | 'boolean';
type Complexity = 'O(1)' | 'O(n)' | 'O(n^2)' | 'O(log n)' | 'O(n log n)';

const colorMap: Record<string, Color> = {
  Easy: colors.green,
  Medium: colors.yellow,
  Hard: colors.red,
  void: colors.gray,
  string: colors.green,
  number: colors.blue,
  boolean: colors.cyan,
  'O(1)': colors.green,
  'O(n)': colors.yellow,
  'O(n^2)': colors.red,
  'O(log n)': colors.blue,
  'O(n log n)': colors.blue,
};

function toClipboard(text: string) {
  const env = {
    LC_CTYPE: 'UTF-8',
  };
  const copySync = (options: Record<string, string>) =>
    execa.sync('pbcopy', { ...options, env });
  if (typeof text !== 'string') {
    throw new TypeError(`Expected a string, got ${typeof text}`);
  }

  copySync({ input: text });
}

function ansiRegex(): RegExp {
  const pattern = [
    '[\\u001B\\u009B][[\\]()#;?]*(?:(?:(?:(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]+)*|[a-zA-Z\\d]+(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]*)*)?\\u0007)',
    '(?:(?:\\d{1,4}(?:;\\d{0,4})*)?[\\dA-PR-TZcf-nq-uy=><~]))',
  ].join('|');

  return new RegExp(pattern);
}

async function select<T>(message: string, choices: T[]): Promise<string> {
  return await prompt({
    type: 'select',
    name: 'answer',
    message,
    choices: (choices as string[]).map(choice => {
      const color = colorMap[choice];
      return color ? color(choice) : choice;
    }),
  }).then(answer => {
    const { answer: result } = answer as { answer: string };

    const matched = result.match(ansiRegex());
    if (matched) {
      return result
        .replace(matched[0], '')
        .replace(matched[1], '')
        .replace('[39m', '');
    }
    return result;
  });
}

export async function main() {
  const complexity: Complexity[] = [
    'O(1)',
    'O(n)',
    'O(n^2)',
    'O(log n)',
    'O(n log n)',
  ];

  const name = await prompt({
    type: 'input',
    name: 'name',
    message: 'Input template name',
  }).then(answer => {
    const { name } = answer as { name: string };
    return name;
  });
  const difficulty = await select<Difficulty>('Select difficulty', [
    'Easy',
    'Medium',
    'Hard',
  ]);
  const returnType = await select<ReturnType>('Select return type', [
    'void',
    'string',
    'number',
    'boolean',
  ]);
  const timeComplexity = await select<Complexity>(
    'Select time complexity',
    complexity
  );
  const spaceComplexity = await select<Complexity>(
    'Select space complexity',
    complexity
  );

  toClipboard(
    `| ${name} | ${difficulty} | ${returnType} | ${timeComplexity} | ${spaceComplexity} |`
  );
}

main();
