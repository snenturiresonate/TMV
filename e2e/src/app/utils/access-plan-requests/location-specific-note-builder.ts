/* tslint:disable */
import {LocationSpecificNote} from '../../../../../src/app/api/linx/models/location-specific-note';

export class LocationSpecificNoteBuilder {
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

  build(): LocationSpecificNote {
    return new LocationSpecificNote(
      this.note,
      this.noteType
    )
  }
}
