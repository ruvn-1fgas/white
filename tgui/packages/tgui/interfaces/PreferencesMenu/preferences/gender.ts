export enum Gender {
  Male = 'male',
  Female = 'female',
  Other = 'plural',
  Other2 = 'neuter',
}

export const GENDERS = {
  [Gender.Male]: {
    icon: 'mars',
    text: 'He/Him',
  },

  [Gender.Female]: {
    icon: 'venus',
    text: 'She/Her',
  },
};
