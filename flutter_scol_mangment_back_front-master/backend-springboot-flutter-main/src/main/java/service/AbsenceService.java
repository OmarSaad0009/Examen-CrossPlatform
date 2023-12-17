package service;

import org.isetn.entities.Absence;
import org.isetn.repository.AbsenceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class AbsenceService {

    private final AbsenceRepository absenceRepository;

    @Autowired
    public AbsenceService(AbsenceRepository absenceRepository) {
        this.absenceRepository = absenceRepository;
    }

    // Method to fetch absences by matiereId and date
 /*   public List<Absence> getAbsencesByMatiereIdAndDate(Long matiereId, Date date) {
        return absenceRepository.findByMatiereIdAndDate(matiereId, date);
    }
*/
    // Other methods in the service class
}
