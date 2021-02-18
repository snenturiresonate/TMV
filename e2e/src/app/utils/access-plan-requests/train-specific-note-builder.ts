/* tslint:disable */
import {TrainSpecificNote} from '../../../../../src/app/api/linx/models/train-specific-note';

export class TrainSpecificNoteBuilder {
  private note?: string;
  private noteType?: string;

  withNote(note: string) {
    this.note = note;
    return this;
  }

  withNoteType(noteType: string) {
    this.noteType = noteType;
    return this;
  }

  build(): TrainSpecificNote {
    return new TrainSpecificNote(
      this.note,
      this.noteType
    );
  }
}
